import 'package:fitmate_app/view_model/account/join/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinViewModel.dart';
import 'package:fitmate_app/view_model/code/ValidateCodeViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInputWithButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAlert.dart';
import '../../widget/CustomAppBar.dart';
import 'AccountJoinView4.dart';

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
    final codeViewModelNotifier = ref.read(validateCodeViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 3,
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
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.1,
                            ),
                            _PhoneInputSection(),
                            SizedBox(
                              height: deviceSize.height * 0.1,
                            ),
                            _CodeInputSection(),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      _NextButton3(),
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

class _PhoneInputSection extends ConsumerWidget {
  const _PhoneInputSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(accountJoinViewModelProvider.notifier);
    final codeViewModelNotifier = ref.read(validateCodeViewModelProvider.notifier);
    final codeViewModel = ref.watch(validateCodeViewModelProvider);
    final viewModel = ref.watch(accountJoinViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);

    return CustomInputWithButton(
      deviceSize: deviceSize,
      onChangeMethod: (value) {
        viewModelNotifier.setPhone(value);
        if (codeViewModel.isChecked) {
          codeViewModelNotifier.reset();
        }
      },
      hintText: '010-0000-0000',
      onPressMethod: () async {
        codeViewModelNotifier.reset();
        final phone = ref.read(accountJoinViewModelProvider).phone;
        final validateResult = await viewModelNotifier
            .validateDuplicatedPhone();
        validateResult.when(
          data: (_) {
            codeViewModelNotifier
                .requestValidateCode(phone);
          },
          error: (error, stackTrace) => showDialog(
              context: context,
              builder: (BuildContext context) {
                List<String> errorArr =
                    '$error'.split('||');
                return CustomAlert(
                    title: errorArr[0],
                    content: errorArr[1],
                    deviceSize: deviceSize);
              }),
          loading: () => CircularProgressIndicator(),
        );
      },
      buttonTitle:
          !codeViewModel.isVisibleCheckView
              ? '인증요청'
              : '재요청',
      isEnableButton: viewModel.phone != '' &&
          errorViewModel.phoneError == null &&
          !codeViewModel.isChecked,
      maxLength: 11,
      isEnableInput: true,
      text: '',
    );
  }
}

class _CodeInputSection extends ConsumerWidget {
  const _CodeInputSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final codeViewModel = ref.watch(validateCodeViewModelProvider);
    final codeViewModelNotifier = ref.read(validateCodeViewModelProvider.notifier);

    if (!codeViewModel.isVisibleCheckView) {
      return SizedBox.shrink();
    }

    return CustomInputWithButton(
      deviceSize: deviceSize,
      onChangeMethod: (value) =>
          codeViewModelNotifier.setCode(value),
      hintText: '인증번호 8자리를 입력해주세요.',
      onPressMethod: () async {
        final phone = ref.read(accountJoinViewModelProvider).phone;
        final code = ref.read(validateCodeViewModelProvider).code!;
        final checkResult =
            await codeViewModelNotifier.checkValidateCode(
                phone, code);
        checkResult.when(
          data: (_) => codeViewModelNotifier.setIsChecked(true),
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
      buttonTitle: '인증확인',
      isEnableButton:
          codeViewModel.code != null &&
              codeViewModel.code != '',
      maxLength: 8,
      text: '',
    );
  }
}

class _NextButton3 extends ConsumerWidget {
  const _NextButton3();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final codeViewModel = ref.watch(validateCodeViewModelProvider);

    return Center(
      child: CustomButton(
        deviceSize: deviceSize,
        onTapMethod: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccountJoinView4())),
        title: '다음',
        // TODO: 인증 확인시에만 활성화 로직 추가 필요
        isEnabled: codeViewModel.isChecked,
      ),
    );
  }
}
