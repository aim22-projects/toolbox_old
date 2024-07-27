import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

typedef SharedMediaListener = void Function(List<SharedMediaFile>?);

class SharingService {
  StreamSubscription? _intentSub;

  static SharingService get instance => SharingService();

  void listen(SharedMediaListener listener) {
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
          listener,
          onError: (err) => listener(null),
        );

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then(listener);
  }

  void dispose() {
    if (_intentSub != null) {
      _intentSub?.cancel();
    }
  }
}
