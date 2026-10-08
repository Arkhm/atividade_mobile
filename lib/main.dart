import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // GlobalKey: dá acesso ao estado do Form para chamar validate()
  final _formKey = GlobalKey<FormState>();

  // TextEditingController: lê/escreve o valor digitado em cada campo
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Mostrar/ocultar senha
  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;

  // Validação em tempo real (onChanged): força da senha
  String _forcaSenha = '';

  @override
  void dispose() {
    // Boa prática: liberar memória dos controllers
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _atualizarForcaSenha(String valor) {
    setState(() {
      if (valor.isEmpty) {
        _forcaSenha = '';
      } else if (valor.length < 6) {
        _forcaSenha = 'Fraca';
      } else if (valor.length < 10) {
        _forcaSenha = 'Média';
      } else {
        _forcaSenha = 'Forte';
      }
    });
  }

  void _cadastrar() {
    // validate() executa o validator de todos os campos de uma vez
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cadastro realizado com sucesso! Olá, ${_nomeController.text}.',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
      _formKey.currentState!.reset();
      _nomeController.clear();
      _emailController.clear();
      _cpfController.clear();
      _telefoneController.clear();
      _senhaController.clear();
      _confirmarSenhaController.clear();
      setState(() => _forcaSenha = '');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Corrija os campos destacados.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  hintText: 'Digite seu nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Digite seu e-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'Digite um e-mail válido';
                  }
                  final emailRegex =
                      RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // CPF (apenas números)
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Somente números (11 dígitos)',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu CPF';
                  }
                  if (value.length != 11) {
                    return 'CPF inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Telefone (apenas números)
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DDD + número (somente números)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu telefone';
                  }
                  if (value.length < 10) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Senha (mínimo 6 caracteres) + força em tempo real
              TextFormField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                onChanged: _atualizarForcaSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Mínimo 6 caracteres',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    tooltip: _ocultarSenha ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(_ocultarSenha
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _ocultarSenha = !_ocultarSenha),
                  ),
                  border: const OutlineInputBorder(),
                  helperText: _forcaSenha.isEmpty
                      ? null
                      : 'Força da senha: $_forcaSenha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite uma senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve possuir pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirmação de senha
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: _ocultarConfirmacao,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  hintText: 'Repita a senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _ocultarConfirmacao
                        ? 'Mostrar senha'
                        : 'Ocultar senha',
                    icon: Icon(_ocultarConfirmacao
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(
                        () => _ocultarConfirmacao = !_ocultarConfirmacao),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (value != _senhaController.text) {
                    return 'As senhas não conferem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _cadastrar,
                  child: const Text('CADASTRAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
