import 'package:fitmate_app/view/account/AccountJoinView2.dart';
import 'package:fitmate_app/view_model/AccountJoinViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountJoinView1 extends ConsumerStatefulWidget {
  const AccountJoinView1({super.key});

  @override
  ConsumerState<AccountJoinView1> createState() => _AccountJoinView1State();
}

class _AccountJoinView1State extends ConsumerState<AccountJoinView1> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(accountJoinViewModelProvider.notifier);
    final viewModel = ref.watch(accountJoinViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
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
                    width: deviceSize.width / 4,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 6,
                    width: deviceSize.width / 4 * 3,
                  ),
                ],
              ),
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              IconButton(
                onPressed: () {
                  viewModelNotifier.reset();
                  Navigator.pop(context);
                },
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
                      '아이디를 입력해주세요',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    Text(
                      '로그인 시 사용할 아이디를 입력해주세요.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.1,
                    ),
                    CustomInput(
                      deviceSize: deviceSize,
                      onChangeMethod: (value) => viewModelNotifier.setLoginName(value),
                      hintText: 'amsidl777',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.35,
              ),
              Center(
                child: CustomButton(
                      deviceSize: deviceSize,
                      onTapMethod: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountJoinView2())),
                      title: '다음',
                      isEnabled: viewModel.loginName != '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
