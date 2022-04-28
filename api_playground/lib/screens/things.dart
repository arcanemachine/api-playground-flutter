// ignore: unused_import
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:api_playground/widgets.dart';
import 'package:api_playground/helpers.dart';
import 'package:api_playground/stores/things.dart';

final store = ThingsStore();

class ThingsScreen extends StatelessWidget {
  const ThingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.auth.loggedInAppBar(context, "Your Things"),
      body: const Center(
        child: ThingsListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const ThingCreateWidget(),
        ),
        tooltip: "Create new Thing",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ThingsListWidget extends StatelessWidget {
  const ThingsListWidget({Key? key}) : super(key: key);

  Widget _initialLoadingWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
            height: 32.0, width: 32.0, child: CircularProgressIndicator()),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Loading...",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _thingsList(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Your Things",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
            // physics: const AlwaysScrollableScrollPhysics(),
            itemCount: store.things.isNotEmpty ? store.things.length : 1,
            itemBuilder: (BuildContext context, int i) {
              return store.things.isEmpty
                  ? const Text(
                      "You have not created any Things.",
                      textAlign: TextAlign.center,
                    )
                  : ListTile(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _thingMenu(context, store.things[i].id),
                      ),
                      title: Text(
                        "- ${store.things[i].name}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _thingMenu(BuildContext context, int thingId) {
    return AlertDialog(
      title: const Text("Manage this Thing", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text("Edit this Thing"),
            onTap: () => showDialog(
              context: context,
              builder: (_) => ThingUpdateAlertDialog(thingId: thingId),
            ),
          ),
          ListTile(
            title: const Text("Delete this Thing"),
            onTap: () {},
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () async => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!store.initialFetchCompleted) {
          return _initialLoadingWidget(context);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await store.thingsFetch();
          },
          child: _thingsList(context),
        );
      },
    );
  }
}

// create
class ThingCreateWidget extends StatefulWidget {
  const ThingCreateWidget({Key? key}) : super(key: key);

  @override
  State<ThingCreateWidget> createState() => _ThingCreateWidgetState();
}

class _ThingCreateWidgetState extends State<ThingCreateWidget> {
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  String _errorText = "";

  void _handleSubmit() async {
    String _thingName = _controller.text;

    setState(() { _isLoading = true; });

    // create thing
    try {
      await store.thingCreate(_thingName).then((x) {
        setState(() { _isLoading = false; });

        widgetHelpers.snackBarShow(context, "Thing created: $_thingName");

        // close the AlertDialog
        Navigator.pop(context);
      });
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Flexible(fit: FlexFit.tight, child: Text("Create New Thing")),
          SizedBox(
            height: 16.0, width: 16.0,
            child: _isLoading ?
              const CircularProgressIndicator() : const SizedBox.shrink(),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _controller,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              hintText: "New Thing name",
              labelText: "Name",
            ),
            onChanged: (x) => setState(() {}),
            onFieldSubmitted: (x) async => _handleSubmit(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child:_errorText != ""
              ? Text(_errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                  )
                )
              : const SizedBox(height: 16.0),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: _controller.text.isNotEmpty&& !_isLoading ?
            () { _handleSubmit(); } : null,
          ),
      ],
    );
  }
}

// update
class ThingUpdateAlertDialog extends StatefulWidget {
  const ThingUpdateAlertDialog({
    Key? key, required this.thingId
  }) : super(key: key);

  final int thingId;

  @override
  State<ThingUpdateAlertDialog> createState() => _ThingUpdateAlertDialogState();
}

class _ThingUpdateAlertDialogState extends State<ThingUpdateAlertDialog> {
  final _controller = TextEditingController();

  void _handleSubmit() async {
    String _thingName = _controller.text;

    // create thing
    try {
      await store.thingUpdate(widget.thingId, _thingName).then((x) {
        widgetHelpers.snackBarShow(context, "Thing created: $_thingName");
      });
    } catch (e) {
      widgetHelpers.snackBarShow(context, e);
    }

    // close the AlertDialog
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create New Thing"),
      content: TextFormField(
        controller: _controller,
        onChanged: (val) => setState(() {}),
        decoration: const InputDecoration(hintText: "Name of this Thing"),
        onFieldSubmitted: (x) async => _handleSubmit(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () => _controller.text.isNotEmpty ? _handleSubmit() : null,
        ),
      ],
    );
  }
}

// delete
