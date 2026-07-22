import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/edit_profile_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';
import '../../../auth/providers/log_out_provider.dart';
import '../../../auth/providers/profile_provider.dart';
import '../../../auth/ui/widgets/button_template.dart';
import '../../../auth/ui/widgets/snack_bar.dart';
import '../widgets/profile_item.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final editProvider = context.watch<EditProfileProvider>();
    final firstNameController = TextEditingController();
    final secondNamecontroller = TextEditingController();
    final majorController = TextEditingController();
    final profile = provider.profile;
    final _formKey = GlobalKey<FormState>();
    final logoutProvider = context.watch<LogoutProvider>();
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profile == null) {
      return const Scaffold(
        body: Center(
          child: Text("لا توجد بيانات"),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/Images/Ellipse 4.png',
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/Images/Ellipse 7.png',
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xff2A9D8F),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 60,
                          )
                        ),

                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xff2A9D8F),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${profile.firstName} ${profile.lastName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal",
                            fontSize:30,
                            color: Color(0xff264653),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Center(child: Text("تعديل الاسم",style: TextStyle(fontSize:26,color:Color(0xff181C1F),fontFamily: "Tajawal",),)),
                                content: Form(
                                  key: _formKey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: firstNameController,
                                          cursorColor: const Color(0xff2A9D8F),
                                          decoration: InputDecoration(
                                            hintText: "الاسم",
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xff2A9D8F),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: secondNamecontroller,
                                          cursorColor: const Color(0xff2A9D8F),
                                          decoration:  InputDecoration(
                                            hintText: "الكنية",
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xff2A9D8F),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Consumer<EditProfileProvider>(
                              builder: (context, editProvider, child) {
                                return editProvider.isLoading
                                    ? const Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Color(0xff2A9D8F),
                                    ),
                                  ),
                                )
                                : ButtonTemplate(
                            text: "تعديل",
                            onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                            await editProvider.editProfile(
                            firstName: firstNameController.text,
                            secondName :secondNamecontroller.text,
                            );
                            if (editProvider.isSuccess) {
                              await context.read<ProfileProvider>().getProfile();

                                Navigator.pop(context);
                            }
                             else if (editProvider.errorMessage != null) {
                            MySnackBar.show(
                            context,
                            message: editProvider.errorMessage!,
                            );
                            }
                            }
                            },
                            );
                            },
                            ),
                                  ),
                                ],
                              )
                            );
                          },
                          icon: Icon(Icons.edit,
                            color: Color(0xff2A9D8F),
                            size:20),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      profile.major,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff264653),
                        fontFamily: "Tajawal",
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            offset: const Offset(0, 6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xff2A9D8F),
                                ),
                                const SizedBox(width: 12),

                                Text(
                                  profile.email,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Tajawal",
                                  ),
                                ),

                              ],
                            ),
                            const Divider(height: 30),

                            Row(
                              children: [
                                const Icon(
                                  Icons.badge_outlined,
                                  color: Color(0xff2A9D8F),
                                ),
                                const SizedBox(width: 12),

                                Text(
                                  "${profile.role} / ${profile.major}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Tajawal",
                                  ),
                                ),

                                const Spacer(),

                                IconButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Center(child: Text("تعديل الاختصاص",style: TextStyle(fontSize:26,color:Color(0xff181C1F),fontFamily: "Tajawal",),)),
                                          content: Form(
                                            key: _formKey,
                                            child: TextField(
                                              controller: majorController,
                                              cursorColor: const Color(0xff2A9D8F),
                                              decoration: InputDecoration(
                                                hintText: "الاختصاص",
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff2A9D8F),
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actions: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Consumer<EditProfileProvider>(
                                                builder: (context, editProvider, child) {
                                                  return editProvider.isLoading
                                                      ? const Center(
                                                    child: SizedBox(
                                                      width: 28,
                                                      height: 28,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        color: Color(0xff2A9D8F),
                                                      ),
                                                    ),
                                                  )
                                                      : ButtonTemplate(
                                                    text: "تعديل",
                                                    onPressed: () async {
                                                      if (_formKey.currentState!.validate()) {
                                                        await editProvider.editProfile(
                                                            major : majorController.text
                                                        );
                                                        if (editProvider.isSuccess) {
                                                          await context.read<ProfileProvider>().getProfile();

                                                          Navigator.pop(context);
                                                        } else if (editProvider.errorMessage != null) {
                                                          MySnackBar.show(
                                                            context,
                                                            message: editProvider.errorMessage!,
                                                          );
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xff2A9D8F),
                                  ),
                                ),
                              ],
                            ),                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    profileItem(
                      Icons.school_outlined,
                      "الدورات المسجلة",
                    ),

                    const SizedBox(height: 5),

                    profileItem(
                      Icons.favorite_border,
                      "المفضلة",
                    ),

                    const SizedBox(height: 25),

                SizedBox(
                  width: 240,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: logoutProvider.isLoading
                        ? null
                        : () async {
                      await logoutProvider.logout();

                      if (logoutProvider.isSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignInPage(),
                          ),
                              (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2A9D8F),
                      foregroundColor: Colors.white,
                    ),
                    child: logoutProvider.isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          "تسجيل الخروج",
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                )],
                ),
              ),
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xff2A9D8F),
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}