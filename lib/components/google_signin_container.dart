import 'package:authentication_sample_with_supabase_flutter/utils/google_sign_in_option_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GoogleSigninContainer extends HookWidget {
  final bool isLoading;
  final Function()? onPressed;
  final List<String> selectedScopes;
  final Function(bool?, String)? onChangedScopeUrl;

  const GoogleSigninContainer({
    super.key,
    required this.isLoading,
    required this.selectedScopes,
    this.onPressed,
    this.onChangedScopeUrl,
  });

  @override
  Widget build(BuildContext context) {
    final options = getPartOfOptions();
    final isExPandedList = useState(
        List<bool>.generate(getPartOfOptions().length, (index) => false));
    return Column(
      children: [
        ExpansionPanelList(
          children: [
            for (int i = 0; i < options.length; i++)
              // ...getPartOfOptions().map(
              //   (optionList) {
              // return ExpansionPanel(
              ExpansionPanel(
                isExpanded: isExPandedList.value[i],
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(options[i].name),
                    onTap: () {
                      final li = List<bool>.of(isExPandedList.value);
                      li[i] = !isExpanded;
                      isExPandedList.value = li;
                    },
                  );
                },
                body: Column(
                  children: [
                    ...options[i].list.map(
                      (e) {
                        final option = e;
                        final isChecked =
                            selectedScopes.contains(option.scopeUrl);
                        return CheckboxListTile(
                          value: isChecked,
                          onChanged: (value) =>
                              onChangedScopeUrl?.call(value, option.scopeUrl),
                          title: Text(option.scopeUrl),
                          subtitle: Text(option.description),
                        );
                      },
                    ).toList()
                  ],
                ),
                // body: ListView.builder(
                //   itemBuilder: (context, index) {
                //     final option = optionList.list[index];
                //     final isChecked =
                //         selectedScopes.contains(option.scopeUrl);
                //     // return CheckboxListTile(
                //     //   value: isChecked,
                //     //   onChanged: (value) =>
                //     //       onChangedScopeUrl?.call(value, option.scopeUrl),
                //     //   title: Text(option.scopeUrl),
                //     //   subtitle: Text(option.description),
                //     // );
                //     return AutoSizeText('${option.scopeUrl}');
                //   },
                //   itemCount: optionList.list.length,
                // ),
                // );
                // },
                // ).toList(),
              ),
          ],
        ),
        ElevatedButton(
          onPressed: onPressed?.call,
          child: const Text('Sign in with Google'),
        ),
      ],
    );
  }
}
