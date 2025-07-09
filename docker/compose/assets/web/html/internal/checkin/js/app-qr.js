var html5QrCode;

function initQr(reader, resultId) {
    Html5Qrcode.getCameras().then(devices => {
        /**
         * devices would be an array of objects of type:
         * { id: "id", label: "label" }
         */
        if (devices && devices.length) {
            var cameraId = devices[0].id;

            html5QrCode = new Html5Qrcode(/* element id */ reader);
            html5QrCode.start(
                cameraId,
                {
                    fps: 10,    // Optional, frame per seconds for qr code scanning
                    qrbox: { width: 250, height: 250 }  // Optional, if you want bounded box UI
                },
                (decodedText, decodedResult) => {
                    onScanSuccess(decodedText, decodedResult, resultId);
                },
                (errorMessage) => {
                    onScanFailure(errorMessage);
                })
                .catch((err) => {
                    // Start failed, handle it.
                });
        }
    }).catch(err => {
        // handle err
    });
}

function onScanSuccess(decodedText, decodedResult, resultId) {

    html5QrCode.pause(true);
    
    if(fhirUpdateAppointment(decodedText)) {
        document.getElementById(resultId).innerText = `Scan erfolgreich! Bitte nehmen Sie im Wartezimmer Platz bis Sie aufgerufen werden.`;
    } else {
        document.getElementById(resultId).innerText = `Ihr Termin konnte nicht gefunden werden. Bitte melden Sie sich beim Empfang!`;
    }


    // Handle the scanned code
    setTimeout(function () { 
        document.getElementById(resultId).innerText = ``;
        html5QrCode.resume();
    }, 5000);
}

function onScanFailure(error) {
    // handle scan failure, usually better to ignore and keep scanning.
}