import 'package:fitmate_app/view/account/AccountJoinView2.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';

class AccountJoinView1 extends ConsumerStatefulWidget {
  const AccountJoinView1({super.key});

  @override
  ConsumerState<AccountJoinView1> createState() => _AccountJoinView1State();
}

class _AccountJoinView1State extends ConsumerState<AccountJoinView1> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery
        .of(context)
        .padding;
    final Size deviceSize = MediaQuery
        .of(context)
        .size;
    final viewModelNotifier = ref.read(accountJoinViewModelProvider.notifier);
    final viewModel = ref.watch(accountJoinViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          resetViewModel: viewModelNotifier,
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 1,
          totalStep: 4,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '아이디를 입력해주세요',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            Text(
                              '로그인 시 사용할 아이디를 입력해주세요.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffE8E8E8),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.1,
                            ),
                            CustomInput(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) =>
                                  viewModelNotifier.setLoginName(value),
                              hintText: 'amsidl777',
                              errorText: errorViewModel.getLoginNameError(),
                              maxLength: 20,
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Center(
                        child: CustomButton(
                          deviceSize: deviceSize,
                          onTapMethod: () async {
                            final validateResult = await viewModelNotifier
                                .validateDuplicatedLoginName();
                            validateResult.when(
                              data: (_) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountJoinView2())),
                              error: (error, stackTrace) =>
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        List<String> errorArr = '$error'.split('||');
                                    return CustomAlert(
                                        title: errorArr[0],
                                        content: errorArr[1],
                                        deviceSize: deviceSize
                                    );
                                  }),
                              loading: () => CircularProgressIndicator(),
                            );
                          },
                          title: '다음',
                          isEnabled: viewModel.loginName != '' &&
                              errorViewModel.getLoginNameError() == null,
                        ),
                      ),
                      SizedBox(
                        height: devicePadding.bottom + deviceSize.height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
