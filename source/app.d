module app;

import std.file;
import std.functional;
import std.path;

import inifiled;

import vibe.core.log;
import vibe.http.router;
import vibe.http.server;

import config;

void index(HTTPServerRequest req, HTTPServerResponse res) {
	string value = req.form.get("value", "");

	res.headers["Content-Type"] = "text/html";
	res.render!("tableview.dt", req, res, value)();
}

void errorPage(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error) {
	res.render!("error.dt", req, error);
}

shared static this() {
	ServerConfig properties;
	auto configFile = buildPath("config","server.ini");
	if (configFile.exists) {
		readINIFile(properties, configFile);
	} else {
		if (!exists("config")) {
			mkdirRecurse("config");
		}
		writeINIFile(properties, configFile);
	}

	auto settings = new HTTPServerSettings;
	settings.port = properties.port;
	settings.errorPageHandler = toDelegate(&errorPage);

	auto router = new URLRouter;
	router.get("/", &index);
	router.post("/", &index);

	listenHTTP(settings, router);

	logInfo("Open your browser to localhost:%s", properties.port);
}
