function notifyReady() {
    frame.sdk.actions.ready();
}

async function requestContext() {
    const context = await frame.sdk.context;
    window.onContextLoaded(context?.user?.username, context?.location);
}

function openUrl(url) {
    frame.sdk.actions.openUrl(url);
}

function downloadImageFromBytes(byteArray, fileName) {
    const blob = new Blob([new Uint8Array(byteArray)], { type: "image/png" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = fileName || "receipt.png";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}
