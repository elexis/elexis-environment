var jwttoken;

function fhirUpdateAppointment(appointmentId) {
    var appointnment = getAppointment(appointmentId);
    var fhirAppointment = JSON.parse(appointnment);
    var success = false;
    if(fhirAppointment.extension != null)  {
        fhirAppointment.extension.forEach(element => {
            if(element.url === "http://elexis.info/codeelement/config/appointment/") {
                element.extension.forEach(element => {
                    if(element.url === "state") {
                        element.valueString = "eingetroffen";
                        updateAppointment(fhirAppointment);
                        success = true;
                    }
                });
            }
        });
    }
    return success;
}

function updateAppointment(fhirAppointment) {
    var xhr = new XMLHttpRequest();
    xhr.withCredentials = true;

    xhr.open("PUT", (typeof SERVER_HOST !== 'undefined' ? SERVER_HOST : "") + "/fhir/Appointment/" + fhirAppointment.id, false);
    xhr.setRequestHeader('Authorization', 'Bearer ' + jwttoken.access_token);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.setRequestHeader("Cache-Control", "no-cache, no-store, max-age=0");

    xhr.send(JSON.stringify(fhirAppointment));
    return xhr.responseText;
}

function getAppointment(appointmentId) {
    var xhr = new XMLHttpRequest();
    xhr.withCredentials = true;

    xhr.open("GET", (typeof SERVER_HOST !== 'undefined' ? SERVER_HOST : "") + "/fhir/Appointment/" + appointmentId, false);
    xhr.setRequestHeader('Authorization', 'Bearer ' + jwttoken.access_token);
    xhr.setRequestHeader("Cache-Control", "no-cache, no-store, max-age=0");

    xhr.send(null);
    return xhr.responseText;
}

function initToken() {
    var tokenJson = getToken();
    jwttoken = JSON.parse(tokenJson);
    console.log(jwttoken.access_token);
}

function getToken() {
    // WARNING: For POST requests, body is set to null by browsers.
    var data = "grant_type=client_credentials&client_id=checkin-app&client_secret=" + CLIENT_SECRET;

    var xhr = new XMLHttpRequest();
    xhr.withCredentials = true;

    xhr.open("POST", (typeof SERVER_HOST !== 'undefined' ? SERVER_HOST : "") + "/keycloak/auth/realms/ElexisEnvironment/protocol/openid-connect/token", false);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.send(data);
    return xhr.responseText;
}