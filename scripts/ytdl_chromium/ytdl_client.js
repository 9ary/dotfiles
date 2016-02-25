var context, genericOnClick, i, len, ref, title, triggerUrl;

triggerUrl = "http://" + HOST + ":" + PORT + "/?i=";

genericOnClick = function(info, tab) {
    var youtubeUrl = info.linkUrl || info.pageUrl;
    var image = new Image();
    return image.src = triggerUrl + youtubeUrl;
};

title = 'Play with mpv';

ref = ['page', 'link'];
for (i = 0, len = ref.length; i < len; i++) {
    context = ref[i];
    chrome.contextMenus.create({
        'title': title,
        'contexts': [context],
        'onclick': genericOnClick
    });
}
