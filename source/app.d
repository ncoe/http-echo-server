module app;

import vibe.appmain;
import vibe.http.form;
import vibe.http.router;
import vibe.http.server;


class App {
	private string m_prefix;

	this(URLRouter router, string prefix="/")
	{
		m_prefix = prefix.length == 0 || prefix[$-1] != '/' ?  prefix ~ "/" : prefix;
		registerFormInterface(router, this, prefix);
	}

	@property string prefix() const
	{
		return m_prefix;
	}

	void index(HTTPServerRequest req, HTTPServerResponse res)
	{
		getecho(req, res, "");
	}

	void getecho(HTTPServerRequest req, HTTPServerResponse res, string value)
	{
		res.headers["Content-Type"] = "text/html";
		//res.render!("tableview.dt", req, res, value)();
		res.renderCompat!("tableview.dt",
		                    HTTPServerRequest, "req",
		                    HTTPServerResponse, "res",
		                    string, "value")(req, res, value);
	}
}

shared static this()
{
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	auto router = new URLRouter;
	auto app = new App(router);
	listenHTTP(settings, router);
}
