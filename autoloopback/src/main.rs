use std::error::Error;

const CARD_NAME: &str = "hw:CARD=Creative";

const CHANNELS: u32 = 2;
const SAMPLE_RATE: u32 = 48000;
const BUFFER_FRAMES: u32 = SAMPLE_RATE / 10;

const RMS_THRESHOLD: f64 = 10.;
// This saves one division and one square root per cycle, compared to doing the entire RMS
// calculation. Results should be the same.  I'm probably over-optimizing this but hey.
const RMS_THRESHOLD_EXPANDED: f64 = RMS_THRESHOLD * RMS_THRESHOLD * BUFFER_FRAMES as f64;

const HYSTERESIS: usize = (SAMPLE_RATE / BUFFER_FRAMES * 3) as usize;

fn main() -> Result<(), Box<dyn Error>> {
    let mixer = alsa::Mixer::new(CARD_NAME, false)?;
    let sid = alsa::mixer::SelemId::new("Loopback Mixing", 0);
    let selem = mixer.find_selem(&sid).ok_or("Mixer element not found")?;

    // TODO figure out how to select which input to capture
    let pcm = alsa::PCM::new(CARD_NAME, alsa::Direction::Capture, false)?;
    let hwp = alsa::pcm::HwParams::any(&pcm)?;
    hwp.set_channels(CHANNELS)?;
    hwp.set_rate(SAMPLE_RATE, alsa::ValueOr::Nearest)?;
    hwp.set_format(alsa::pcm::Format::s16())?;
    hwp.set_access(alsa::pcm::Access::RWInterleaved)?;
    hwp.set_buffer_size_near(BUFFER_FRAMES as alsa::pcm::Frames)?;
    pcm.hw_params(&hwp)?;
    let io = pcm.io_i16()?;

    selem.set_enum_item(alsa::mixer::SelemChannelId::mono(), 0)?;
    let mut enabled = false;
    let mut last_volumes = [0.; HYSTERESIS];
    let mut cursor = 0;

    loop {
        let mut buf: [i16; (BUFFER_FRAMES * CHANNELS) as usize] = unsafe {
            std::mem::uninitialized()
        };
        let frames = io.readi(&mut buf)?;
        let acc = buf[..frames * CHANNELS as usize].iter().map(|&s| s as f64 * s as f64).sum();

        last_volumes[cursor] = acc;
        cursor = (cursor + 1) % HYSTERESIS;
        let max = last_volumes.iter().fold(0f64, |m, v| m.max(*v));
        if enabled != (max > RMS_THRESHOLD_EXPANDED) {
            enabled = !enabled;
            selem.set_enum_item(alsa::mixer::SelemChannelId::mono(), enabled as u32)?;
        }
    }
}
