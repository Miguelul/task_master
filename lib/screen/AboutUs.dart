import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUsScreen extends StatefulWidget
{
  static const String routeName = "/about_us";

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
{
  bool _loading = false;
   late WebViewController _controller;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: ModalProgressHUD(
          child:Builder(builder: (BuildContext context)
          {
            return WebView(
              //initialUrl: ''
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                _loadHtmlFromAssets();
                //print("onWebViewCreated");
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request)
              {
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url)
              {
                print('Page started loading: $url');
                setState(()
                {
                  _loading = true;
                });
              },
              onPageFinished: (String url)
              {
                print('Page finished loading: $url');
                setState(()
                {
                  _loading = false;
                });
              },
              gestureNavigationEnabled: true,
            );
          }), inAsyncCall: _loading
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context)
  {
    return JavascriptChannel
      (
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message)
        {
        
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
);
        }
    );
  }

  _loadHtmlFromAssets() async
  {
    String fileText = await rootBundle.loadString('assets/aboutus.html');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
