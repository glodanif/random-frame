function notifyReady() {
    frame.sdk.actions.ready();
}

function closeFrame() {
    frame.sdk.actions.close();
}

async function requestContext() {
    const context = await frame.sdk.context;
    window.onContextLoaded(context?.user?.username, context?.location);
}

async function openUrl(url) {
    await frame.sdk.actions.openUrl(url);
}
