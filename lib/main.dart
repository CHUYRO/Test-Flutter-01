import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('mqtt3.thingspeak.com', '5');
int subChannelID = 2;

void main() async {
  /// Set logging on if needed, defaults to off
  client.logging(on: false);

  /// Set the correct MQTT protocol for testing against mosquito
  client.setProtocolV311();

  /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
  client.keepAlivePeriod = 10;

  /// The connection timeout period can be set if needed, the default is 5 seconds.
  client.connectTimeoutPeriod = 2000; // milliseconds

  /// Set auto reconnect
  client.autoReconnect = true;

  /// If you do not want active confirmed subscriptions to be automatically re subscribed
  /// by the auto connect sequence do the following, otherwise leave this defaulted.
  client.resubscribeOnAutoReconnect = false;

  /// Add an auto reconnect callback.
  /// This is the 'pre' auto re connect callback, called before the sequence starts.
  client.onAutoReconnect = onAutoReconnect;

  /// Add an auto reconnect callback.
  /// This is the 'post' auto re connect callback, called after the sequence
  /// has completed. Note that re subscriptions may be occurring when this callback
  /// is invoked. See [resubscribeOnAutoReconnect] above.
  client.onAutoReconnected = onAutoReconnected;

  /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
  /// You can add these before connection or change them dynamically after connection if
  /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
  /// can fail either because you have tried to subscribe to an invalid topic or the broker
  /// rejects the subscribe request.
  client.onSubscribed = onSubscribed;

  final connMess = MqttConnectMessage()
      .withClientIdentifier('JgAIKS43DQAWAjQmChUWMw0')
      .withWillTopic('channels/${subChannelID.toString()}/subscribe') // If you set this you must set a will message
      .withWillMessage('')
      .startClean() // Non persistent session for testing
      .authenticateAs('JgAIKS43DQAWAjQmChUWMw0', 'OmcGA0PqW7CqSPt4o+UEMJ+Z')
      .withWillQos(MqttQos.atMostOnce); // means = 0
  print('client connecting....');
  client.connectionMessage = connMess;

  /// Create a connection message to use or use the default one. The default one sets the
  /// client identifier, any supplied username/password and clean session,
  /// an example of a specific one below.
/*   final connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueId')
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atLeastOnce);
  print('EXAMPLE::Mosquitto client connecting....');
  client.connectionMessage = connMess; */

  /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
  /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
  /// never send malformed messages.
  try {
    await client.connect();
  } on Exception catch (e) {
    print('EXAMPLE::client exception - $e');
    client.disconnect();
  }

  /// Check we are connected
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('EXAMPLE::MQTT client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'EXAMPLE::ERROR MQTT client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

/*   /// Ok, lets try a subscription
  print('EXAMPLE::Subscribing to the test/lol topic');
  const topic = 'test/lol'; // Not a wildcard topic
  client.subscribe(topic, MqttQos.atMostOnce); */

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
  });

  /// If needed you can listen for published messages that have completed the publishing
  /// handshake which is Qos dependant. Any message received on this stream has completed its
  /// publishing handshake with the broker.
  client.published!.listen((MqttPublishMessage message) {
    print(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

  /// Lets publish to our topic
  /// Use the payload builder rather than a raw buffer
  /// Our known topic to publish to
/*   const pubTopic = 'Dart/Mqtt_client/testtopic';
  final builder = MqttClientPayloadBuilder();
  builder.addString('Hello from mqtt_client'); */

/*   /// Subscribe to it
  print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
  client.subscribe(pubTopic, MqttQos.exactlyOnce);

  /// Publish it
  print('EXAMPLE::Publishing our topic');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!); */

  /// Ok, we will now sleep a while, in this gap you will see ping request/response
  /// messages being exchanged by the keep alive mechanism.
/*   print('EXAMPLE::Sleeping....');
  await MqttUtilities.asyncSleep(60); */

/*   /// Finally, unsubscribe and exit gracefully
  print('EXAMPLE::Unsubscribing');
  client.unsubscribe(topic); */

/*   /// Wait for the unsubscribe message from the broker if you wish.
  await MqttUtilities.asyncSleep(2);
  print('EXAMPLE::Disconnecting');
  client.disconnect(); */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'VOXVOX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'VOX',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('EXAMPLE::Subscription confirmed for topic $topic');
}

/// The pre auto re connect callback
void onAutoReconnect() {
  print(
      'EXAMPLE::onAutoReconnect client callback - Client auto reconnection sequence will start');
}

/// The post auto re connect callback
void onAutoReconnected() {
  print(
      'EXAMPLE::onAutoReconnected client callback - Client auto reconnection sequence has completed');
}

/// The successful connect callback
void onConnected() {
  print(
      'EXAMPLE::OnConnected client callback - Client connection was successful');
}

/// The successful connect callback
void onDisconnected() {
  print(
      'EXAMPLE::OnDesconnected client callback - Client Desconnection was successful');
}

/// Pong callback
void pong() {
  print(
      'EXAMPLE::Ping response client callback invoked - you may want to disconnect your broker here');
}
