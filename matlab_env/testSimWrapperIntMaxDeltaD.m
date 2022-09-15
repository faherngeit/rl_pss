function testSimWrapperIntMaxDeltaD(pathToLog)
response = simWrapper("ten_almost_similar", "IntMaxDeltaD", 1000, 1, pathToLog, pathToLog);
assert(response.StatusLine.StatusCode == matlab.net.http.StatusLine('HTTP/1.1 200 OK').StatusCode, ...
    "TEST FAILED. Error in POST /train/ with status code %i", response.StatusLine.StatusCode)
disp("TEST PASSED");
end