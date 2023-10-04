class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final pinController = TextEditingController();
  bool? pinSuccess;
  bool buttonLoading = false;

  final PinTheme successTheme = PinTheme(
    width: 56.r,
    height: 50.r,
    textStyle: TextStyle(
      fontFamily: 'numbers',
      fontSize: 22.sp,
      fontWeight: FontWeight.w500,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.green,
      ),
      borderRadius: BorderRadius.circular(10.r),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.sw(),
              height: kToolbarHeight,
            ),
            16.verticalSpace,
            Text(
              'Verify its you!',
              style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'metro'),
            ),
            4.verticalSpace,
            Text(
              'Please enter OTP sent to\n+91 9744477794',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  fontFamily: 'metro',
                  height: 1.3,
                  color: const Color.fromARGB(255, 93, 93, 93)),
            ),
            16.verticalSpace,
            Pinput(
              enabled: false,
              controller: pinController,
              length: 6,
              defaultPinTheme: pinSuccess != null && (pinSuccess ?? false)
                  ? successTheme
                  : PinTheme(
                      width: 45.r,
                      height: 45.r,
                      textStyle: TextStyle(
                        fontFamily: 'numbers',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 218, 218, 218),
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
            ),
            10.verticalSpace,
            Row(
              children: [
                const Text(
                  'Didn\'t get the Otp? Resend SMS in ',
                  style: TextStyle(
                    fontFamily: 'metro',
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                2.horizontalSpace,
                Text(
                  '00:29',
                  style: TextStyle(
                      fontFamily: 'metro',
                      color: const Color.fromARGB(255, 25, 163, 255),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Theme(
                  data: ThemeData(splashColor: Colors.blue),
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.r),
                          child: const Icon(FeatherIcons.arrowLeft),
                        ),
                        4.horizontalSpace,
                        Text(
                          'Change mobile number?',
                          style:
                              TextStyle(fontFamily: 'metro', fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            6.verticalSpace,
            CustomButton(
              title: 'Verify',
              titleColor: Colors.white,
              onPressed: () {},
            ),
            16.verticalSpace
          ],
        ),
      ),
    );
  }
}
