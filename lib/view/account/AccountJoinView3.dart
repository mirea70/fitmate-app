import 'package:fitmate_app/view/account/AccountJoinView2.dart';
import 'package:fitmate_app/view_model/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/AccountJoinViewModel.dart';
import 'package:fitmate_app/view_model/ValidateCodeViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputWithButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountJoinView3 extends ConsumerStatefulWidget {
  const AccountJoinView3({super.key});

  @override
  ConsumerState<AccountJoinView3> createState() => _AccountJoinView3State();
}

class _AccountJoinView3State extends ConsumerState<AccountJoinView3> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(accountJoinViewModelProvider.notifier);
    final viewModel = ref.read(accountJoinViewModelProvider);
    final codeViewModel = ref.watch(validateCodeViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                      SizedBox(
                        height: devicePadding.top,
                      ),
                      Row(
                        children: [
                          Container(
                            color: Colors.orangeAccent,
                            height: 6,
                            width: deviceSize.width / 4 * 3,
                          ),
                          Container(
                            color: Colors.grey,
                            height: 6,
                            width: deviceSize.width / 4 * 1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceSize.height * 0.01,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        height: deviceSize.height * 0.1,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '휴대 전화번호를 인증해 주세요',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            Text(
                              '신뢰할 수 있는 커뮤니티를 위해 전화번호 인증이 필요해요.',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.1,
                            ),
                            CustomInputWithButton(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) =>
                                  viewModelNotifier.setPhone(value),
                              hintText: '010-0000-0000',
                              onPressMethod: () {
                                viewModelNotifier.validatePhoneWithAPI();
                                codeViewModel.setVisibleCheckView(true);
                              },
                              buttonTitle: !codeViewModel.getIsVisibleCheckView() ?'인증요청' : '재요청',
                              isEnableButton: viewModel.phone != '' && errorViewModel.getPhoneError() == null,
                              maxLength: 11,
                              isEnableInput: !codeViewModel.getIsVisibleCheckView(),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.1,
                            ),
                            if (codeViewModel.getIsVisibleCheckView())
                              CustomInputWithButton(
                                deviceSize: deviceSize,
                                onChangeMethod: (value) =>
                                    codeViewModel.setCode(value),
                                hintText: '인증번호 6자리를 입력해주세요.',
                                onPressMethod: () =>
                                    codeViewModel.checkValidateCode(),
                                buttonTitle: '인증확인',
                                isEnableButton: codeViewModel.getCode() != null && codeViewModel.getCode() != '',
                                maxLength: 6,
                              ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Center(
                        child: CustomButton(
                          deviceSize: deviceSize,
                          onTapMethod: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountJoinView2())),
                          title: '다음',
                          // TODO: 인증 확인시에만 활성화 로직 추가 필요
                          isEnabled: codeViewModel.getIsChecked(),
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
