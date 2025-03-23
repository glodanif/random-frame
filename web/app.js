function notifyReady() {
    console.log('notifyReady')
    frame.sdk.actions.ready();
}

function closeFrame() {
    console.log('closeFrame')
    frame.sdk.actions.close();
}

async function requestContext() {
    console.log('requestContext')
    const context = await frame.sdk.context;
    window.onContextLoaded(context?.user?.username, context?.location);
}

async function openUrl(url) {
    console.log(`openUrl: ${url}`)
    await frame.sdk.actions.openUrl(url);
}
