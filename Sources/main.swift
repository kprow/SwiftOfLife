//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(request: HTTPRequest, response: HTTPResponse) {
	// Respond with a simple message.
	response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: """
<html>
<head>
<style>
/* Document
   ========================================================================== */

/**
 * 1. Correct the line height in all browsers.
 * 2. Prevent adjustments of font size after orientation changes in iOS.
 */

html {
  line-height: 1.15; /* 1 */
  -webkit-text-size-adjust: 100%; /* 2 */
}

/* Sections
   ========================================================================== */

/**
 * Remove the margin in all browsers.
 */

body {
  margin: 0;
}

/**
 * Correct the font size and margin on `h1` elements within `section` and
 * `article` contexts in Chrome, Firefox, and Safari.
 */

h1 {
  font-size: 2em;
  margin: 0.67em 0;
}


/******/

body {
  font-family: -apple-system,BlinkMacSystemFont,"Lucida Grande","Segoe UI",Ubuntu,Roboto,"Droid Sans",Tahoma,sans-serif;
}

header {
  margin-bottom: 2em;
  border-bottom: 1px solid #eee;
  text-align: center;
}

header h1 {
  font-weight: 100;
}

/* board */
.game {
}

/* rows */
.game-row {
  display: flex;
  justify-content: center;
}

/* cells */
.game-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1rem;
  height: 1rem;
  background-color: #bbb;
  border-width: 1px 1px 0 0;
  border-color: #eee;
  border-style: solid;

  text-align: center;
  vertical-align: middle;
  color: #fffeb9;
  /*line-height: 1em;*/
}

/* remove top border on first row cells */
.game-row:first-child .game-cell {
  border-top: none;
}

/* remove right bord on last cell in all rows */
.game-cell:last-child {
  border-right: none;
}

.game-cell div {
  width: .5rem;
  height: .5rem;
  background: #fff7ac;
  border-radius: 50%;
}
</style>
</head>
<body>
    <header>
        <h1>John Conway's Game of Life</h1>
    </header>

    <button id="step" onclick='step()'>Step</button>
    <div id='myGame'></div>
<script>
// self executing function here
(function() {
var gridState = null;
var gameState = {
    'gameInterval': 500,
    'isPlaying': false
}
// your page initialization code here
// the DOM will be available here
var xhr= new XMLHttpRequest();
xhr.open('GET', '/create', true);
xhr.onreadystatechange= function() {
    if (this.readyState!==4) return;
    if (this.status!==200) return; // or whatever error handling you want
    var response = JSON.parse(this.responseText);
    document.getElementById('myGame').innerHTML= response.htmlResult;
    window.gridState = response.jsonResult
};
xhr.send();
})();
function cellClick(id) {
    // 0: cell 1: x 2: y
    var cellAttr = id.split('_')
    var x = cellAttr[1]
    var y = cellAttr[2]
    var cell = document.getElementById(id)
    var innerCell = cell.innerHTML
    // activate (make alive)
    if (innerCell == '') {
        var div = document.createElement('div')
        cell.appendChild(div)
    } else {
    // deactivate
        cell.innerHTML = ''
    }
    window.gridState.rows[y-1].cells[x-1].isAlive = !window.gridState.rows[y-1].cells[x-1].isAlive
    console.log( window.gridState )
}
function step(){
    var stepXHR =  new XMLHttpRequest();
    stepXHR.open('POST', '/step', true);
    stepXHR.onreadystatechange= function() {
        if (this.readyState!==4) return;
        if (this.status!==200) return; // or whatever error handling you want
        var response = JSON.parse(this.responseText);
        document.getElementById('myGame').innerHTML= response.htmlResult;
        window.gridState = response.jsonResult
    };
    stepXHR.setRequestHeader("Content-Type", "application/json");
    stepXHR.send(JSON.stringify(window.gridState))
}
</script>
</body>
</html>
""")
	// Ensure that response.completed() is called when your processing is done.
	response.completed()
}

// Configuration data for an example server.
// This example configuration shows how to launch a server
// using a configuration dictionary.


let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":"localhost",
			"port":8180,
			"routes":[
                ["method":"get", "uri":"/", "handler":handler],
                ["method":"get", "uri":"/create", "handler":CreateGameController.handler],
                ["method":"post", "uri":"/step", "handler":CreateGameController.stepHandler],
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
	]
]

do {
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

