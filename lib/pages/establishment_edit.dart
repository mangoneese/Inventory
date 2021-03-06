import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Inventarios/widgets/helpers/ensure_visible.dart';

import 'package:Inventarios/scoped_models/main.dart';
import 'package:Inventarios/models/establishment.dart';

class EstablishmentEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EstablishmentEditPage();
}

class _EstablishmentEditPage extends State<EstablishmentEditPage> {
  Establishment _formData = new Establishment();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  Widget _buildNameTextField(Establishment establishment) {
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: TextFormField(
        focusNode: _nameFocusNode,
        decoration: InputDecoration(
          labelText: 'Nombre del lugar',
        ),
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Debe tener al menos 5 letras';
          }
        },
        initialValue: establishment == null ? '' : establishment.name,
        onSaved: (String value) {
          _formData.name = value;
        },
      ),
    );
  }

  Widget _buildAddressTextField(Establishment establishment) {
    return EnsureVisibleWhenFocused(
      focusNode: _addressFocusNode,
      child: TextFormField(
        focusNode: _addressFocusNode,
        decoration: InputDecoration(
          labelText: 'Dirección',
        ),
        initialValue: establishment == null ? '' : establishment.address,
        onSaved: (String value) {
          _formData.address = value;
        },
      ),
    );
  }

  void _submitForm(Function addEstablishment, Function updateEstablishment,
      Function setSelectedEstablishment,
      [int selEstablishmentIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (selEstablishmentIndex == null) {
      addEstablishment(_formData.name, _formData.address);
    } else {
      updateEstablishment(_formData.name, _formData.address);
    }

    Navigator.pushReplacementNamed(context, '/establishments')
        .then((_) => setSelectedEstablishment(null));
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Guardar'),
          textColor: Colors.white,
          color: Theme.of(context).accentColor,
          onPressed: () => _submitForm(
              model.addEstablishment,
              model.updateEstablishment,
              model.setSelectedEstablishment,
              model.selEstablishmentIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Establishment establishment) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildNameTextField(establishment),
              SizedBox(
                height: 10.0,
              ),
              _buildAddressTextField(establishment),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget pageContent =
          _buildPageContent(context, model.selectedEstablishment);

      return model.selectedEstablishmentIndex == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Editar Lugar'),
              ),
              body: pageContent,
            );
    });
  }
}
