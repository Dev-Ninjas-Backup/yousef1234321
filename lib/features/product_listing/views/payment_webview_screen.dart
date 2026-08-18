import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String initialUrl;
  final String title;

  const PaymentWebViewScreen({
    super.key,
    required this.initialUrl,
    this.title = 'Complete Payment',
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
          },
          onPageStarted: (String url) {
            _checkUrl(url);
          },
          onPageFinished: (String url) {
            _checkUrl(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            _checkUrl(request.url);
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView resource error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  void _checkUrl(String url) {
    if (_isDone) return;
    final lower = url.toLowerCase();

    // Check for payment success or cancellation callbacks
    if (lower.contains('success') ||
        lower.contains('completed') ||
        lower.contains('status=paid')) {
      _isDone = true;
      EasyLoading.showSuccess('Payment Successful');
      Get.back(result: true);
    } else if (lower.contains('cancel')) {
      _isDone = true;
      EasyLoading.showInfo('Payment Cancelled');
      Get.back(result: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(result: false),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loadingProgress < 100)
            LinearProgressIndicator(
              value: _loadingProgress / 100.0,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFF4A72FF),
            ),
        ],
      ),
    );
  }
}
