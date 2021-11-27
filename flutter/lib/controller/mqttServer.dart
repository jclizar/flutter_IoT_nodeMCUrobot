import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_dibop/controller/subscribItem.dart';

class MqttServer {
  static String broker = "mqtt.eclipseprojects.io";
  static int port = 1883;
  static String mainTopic = "dibop/controller0";
  static String clientIdentifier = 'dibop01';
  static int controllerValue = 0;
  static final client = MqttServerClient(broker, clientIdentifier);

  /// The subscribed callback
  static void _onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  static void _onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }

  /// The successful connect callback
  static void _onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  static void _pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }

  static Future<int> connect() async {
    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// There is also an alternate websocket implementation for specialist use, see useAlternateWebSocketImplementation
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.
    /// You can also supply your own websocket protocol list or disable this feature using the websocketProtocols
    /// setter, read the API docs for further details here, the vast majority of brokers will support the client default
    /// list so in most cases you can ignore this.
    /// Set logging on if needed, defaults to off
    client.logging(on: false);

    client.securityContext = SecurityContext.defaultContext;

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 20;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    /// Add the successful connection callback
    client.onConnected = _onConnected;

    /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
    /// You can add these before connection or change them dynamically after connection if
    /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
    /// can fail either because you have tried to subscribe to an invalid topic or the broker
    /// rejects the subscribe request.
    client.onSubscribed = _onSubscribed;

    /// Set a ping received callback if needed, called whenever a ping response(pong) is received
    /// from the broker.
    client.pongCallback = _pong;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password and clean session,
    /// an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic(mainTopic) // If you set this you must set a will message
        .withWillMessage('0')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }

    /// Ok, lets try a subscription
    // print('EXAMPLE::Subscribing to the test/lol topic');
    // const topic = 'test/lol'; // Not a wildcard topic
    // client.subscribe(topic, MqttQos.atMostOnce);
    client.subscribe(mainTopic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');

      int value = int.parse(pt);

      SubscriptionItem subscriptionItem = new SubscriptionItem("", value);

      FirebaseFirestore.instance
          .collection('subscription')
          .add(subscriptionItem.getMapValues());
    });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    client.published!.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    return 0;
  }

  static Future<int> publish(String value) async {
    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(value);
    return client.publishMessage(
        mainTopic, MqttQos.exactlyOnce, builder.payload!);
  }
}
