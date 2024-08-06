import 'package:debty/src/core/data/debts/debt_service.dart';
import 'package:debty/src/core/models/debt_model.dart';
import 'package:debty/src/core/utils/extentions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtHome extends StatefulWidget {
  const DebtHome({super.key});

  @override
  State<DebtHome> createState() => _DebtHomeState();
}

class _DebtHomeState extends State<DebtHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DebtService>().fetchDebts();
    });
  }

  void updateDate(DateTime dt) {
    setState(() {
      initialDate = AppUtils.formatDate(dateTimeString: '$dt');
    });
  }

  String initialDate = 'Select date';
  void showCreateDebtDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
            title: null,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              final debtFormKey = GlobalKey<FormState>();
              final titleController = TextEditingController();
              final amountController = TextEditingController();

              return SizedBox(
                height: 0250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New debt',
                          style: Theme.of(alertContext)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Colors.black.withOpacity(.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                    Form(
                        key: debtFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleController,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'Enter a name';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'Enter an amount';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    if (mounted) {
                                      final DateTime? fPickedDate =
                                          await showDatePicker(
                                        context: alertContext,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );
                                      if (fPickedDate != null) {
                                        setState(() {
                                          initialDate = AppUtils.formatDate(
                                              dateTimeString: '$fPickedDate');
                                        });
                                      }
                                    }
                                  },
                                  child: Center(child: Text(initialDate)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(

                                  onPressed: () {
                                    if (debtFormKey.currentState!.validate()) {
                                      alertContext
                                          .read<DebtService>()
                                          .createDebt(DebtModel(
                                              title: titleController.text
                                                  .toString(),
                                              amount: amountController.text
                                                  .toString(),
                                              dateTime: initialDate));
                                      Navigator.of(context).pop(true);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                  ),
                                  child: Text(
                                    'Save Debt',
                                      semanticsLabel:"Save new debt",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              );
            }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          tooltip:"Add new debt",
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          onPressed: () {
            showCreateDebtDialog();
          },
        child: const Icon(CupertinoIcons.rectangle),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            pinned: true,
            elevation: kToolbarHeight * 2,
            centerTitle: true,
            title: const Text(
              "Debty",
            ),
            // leading:IconButton(icon: const Icon(CupertinoIcons.back),onPressed: (){},)
          ),
          SliverToBoxAdapter(
            child: Container(
              padding:const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (context.read<DebtService>().currentDebts.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.shortestSide,

                      child: ListView.builder(
                      itemCount:
                          context.read<DebtService>().currentDebts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: ,
                          child: Column(
                            children: [
                              ListTile(
                                // isThreeLine: true,
                                title: Text(context
                                        .read<DebtService>()
                                        .currentDebts[index]
                                        .title ??
                                    'N/A'),
                                subtitle: Text(context
                                        .read<DebtService>()
                                        .currentDebts[index]
                                        .amount ??
                                    'N/A'),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.bars),
                                ),
                              ),
                              const SizedBox(height: 7,)
                            ],
                          ),
                        );
                      }),
                                      )
                  else
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: Text("Saved debtors now you might forget !"),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DebHomeNotifier extends ChangeNotifier {}
