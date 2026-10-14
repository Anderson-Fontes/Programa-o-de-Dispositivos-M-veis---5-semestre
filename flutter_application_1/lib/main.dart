import 'package:flutter/material.dart';

void main() {
  runApp(const CadastroApp());
}

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    const raio = BorderRadius.all(Radius.circular(14));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de participante',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4FB),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: raio),
          enabledBorder: OutlineInputBorder(
            borderRadius: raio,
            borderSide: BorderSide(color: Color(0xFFD0D3E8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: raio,
            borderSide: BorderSide(color: Colors.indigo, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: raio),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: Colors.indigo,
            side: const BorderSide(color: Colors.indigo),
            shape: const RoundedRectangleBorder(borderRadius: raio),
          ),
        ),
      ),
      home: const TelaCadastro(),
    );
  }
}

// Representa os dados preenchidos no formulário.
class Participante {
  final String email;
  final String nome;
  final String telefone;
  final String cpf;

  const Participante({
    required this.email,
    required this.nome,
    required this.telefone,
    required this.cpf,
  });
}

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';

    if (email.isEmpty) {
      return 'Informe o e-mail.';
    }

    final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!formato.hasMatch(email)) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';

    if (nome.isEmpty) {
      return 'Informe o nome.';
    }

    if (nome.length < 3) {
      return 'O nome deve ter pelo menos três caracteres.';
    }

    return null;
  }

  String? _validarTelefone(String? valor) {
    final telefone = valor?.trim() ?? '';

    if (telefone.isEmpty) {
      return 'Informe o telefone.';
    }

    final formato = RegExp(r'^\d{2}-\d{5}-\d{4}$');

    if (!formato.hasMatch(telefone)) {
      return 'Use o formato DD-DDDDD-DDDD.';
    }

    return null;
  }

  String? _validarCpf(String? valor) {
    final cpf = valor?.trim() ?? '';

    if (cpf.isEmpty) {
      return 'Informe o CPF.';
    }

    final formato = RegExp(r'^\d{11}$');

    if (!formato.hasMatch(cpf)) {
      return 'O CPF deve ter exatamente 11 dígitos, sem pontos ou traço.';
    }

    return null;
  }

  void _exibirDados() {
    final formularioValido = _formKey.currentState!.validate();

    if (!formularioValido) {
      return;
    }

    final participante = Participante(
      email: _emailController.text.trim(),
      nome: _nomeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cpf: _cpfController.text.trim(),
    );

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => TelaResumo(participante: participante),
      ),
    );
  }

  void _limpar() {
    _formKey.currentState!.reset();

    _emailController.clear();
    _nomeController.clear();
    _telefoneController.clear();
    _cpfController.clear();

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de participante'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.indigo,
                    child: Icon(
                      Icons.person_add_alt_1,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Informe os dados do participante',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'Ex.: ana@email.com',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            validator: _validarEmail,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              labelText: 'Nome',
                              hintText: 'Ex.: Ana Souza',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: _validarNome,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _telefoneController,
                            decoration: const InputDecoration(
                              labelText: 'Telefone',
                              hintText: 'DD-DDDDD-DDDD',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: _validarTelefone,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cpfController,
                            decoration: const InputDecoration(
                              labelText: 'CPF',
                              hintText: 'Somente 11 números',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: _validarCpf,
                            onFieldSubmitted: (_) => _exibirDados(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _exibirDados,
                    child: const Text(
                      'Exibir dados',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _limpar,
                    child: const Text(
                      'Limpar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TelaResumo extends StatelessWidget {
  final Participante participante;

  const TelaResumo({
    super.key,
    required this.participante,
  });

  @override
  Widget build(BuildContext context) {
    final inicial = participante.nome.isNotEmpty
        ? participante.nome[0].toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do cadastro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.indigo,
                  child: Text(
                    inicial,
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dados do participante',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _LinhaResumo(
                          icone: Icons.email_outlined,
                          rotulo: 'E-mail',
                          valor: participante.email,
                        ),
                        const Divider(height: 1),
                        _LinhaResumo(
                          icone: Icons.person_outline,
                          rotulo: 'Nome',
                          valor: participante.nome,
                        ),
                        const Divider(height: 1),
                        _LinhaResumo(
                          icone: Icons.phone_outlined,
                          rotulo: 'Telefone',
                          valor: participante.telefone,
                        ),
                        const Divider(height: 1),
                        _LinhaResumo(
                          icone: Icons.badge_outlined,
                          rotulo: 'CPF',
                          valor: participante.cpf,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                      'Voltar para editar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Linha de informação do resumo (ícone, rótulo e valor).
class _LinhaResumo extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final String valor;

  const _LinhaResumo({
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icone, color: Colors.indigo),
      title: Text(
        rotulo,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
      subtitle: Text(
        valor,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}