import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:saloon_app/helper/FirestoreHelper.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/models/Pet.dart';
import 'package:saloon_app/models/PetFeed.dart';
import 'package:saloon_app/providers/AuthenticationProvider.dart';
import 'package:saloon_app/providers/ConfigProvider.dart';
import 'package:saloon_app/widgets/DisplayPicture.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> scaffOldKey = GlobalKey();

  ConfigProvider configProvider;

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthenticationProvider>(context, listen: false).initializeUser();
    configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      key: scaffOldKey,
      drawer: Container(
        child: Drawer(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Consumer<AuthenticationProvider>(
                builder: (_, provider, __) {
                  return DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        DisplayPicture('https://qodebrisbane.com/wp-content/uploads/2019/07/This-is-not-a-person-2-1.jpeg', 56.0),
                        Spacer(),
                        Text('${provider.appUser.userName}', style: Theme.of(context).textTheme.headline6),
                        Spacer(),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('My Profile'),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/editProfile');
                },
                leading: Icon(FontAwesomeIcons.user),
              ),
              Divider(height: 1),
              ListTile(
                title: Text('My Pet'),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, '/tasks');
                },
                leading: Icon(FontAwesomeIcons.tasks),
              ),
              Divider(height: 1),
              ListTile(
                title: Text('Logout'),
                dense: true,
                onTap: () async {
                  Navigator.pop(context);
                  // bool logout = await showDialog<bool>(
                  //   context: context,
                  //   builder: (context) {
                  //     return DialogLogout();
                  //   },
                  // );
                  // if (logout != null && logout) {
                  //   bool loggedOut = await Provider.of<LoggedInUserProvider>(context, listen: false).LogUserOut();
                  //   if (loggedOut) {
                  //     Constants.clearData(context);
                  //     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  //   }
                  // }
                },
                leading: Icon(FontAwesomeIcons.signOutAlt),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AuthenticationProvider>(
              builder: (_, provider, __) {
                return Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(left: 16, bottom: 12, right: 16),
                      child: (provider.appUser == null)
                          ? Center(child: CircularProgressIndicator())
                          : ListTile(
                              leading: DisplayPicture('https://qodebrisbane.com/wp-content/uploads/2019/07/This-is-not-a-person-2-1.jpeg', 56.0),
                              title: Text(
                                'Hi, ${provider.appUser.userName}',
                                style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Welcome to app, i\'ll remind you to feed your pet',
                                style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                    ),
                    if ((provider.pet != null && provider.pet.petFeed != null)) ...[
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          'Pet Was Fed !',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'John Smith',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleImageInkWell(
                          image: NetworkImage('https://www.cdc.gov/healthypets/images/pets/cute-dog-headshot.jpg'),
                          onPressed: () {},
                          size: 125,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Feed the ${provider.pet.name}\n${new Jiffy(DateTime.fromMillisecondsSinceEpoch(provider.pet.petFeed.when)).fromNow()}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleImageInkWell(
                          image: NetworkImage('${provider.pet.displayPic}'),
                          onPressed: () {},
                          size: 75,
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                    ] else ...[
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          'Upcoming Reminder\n${Jiffy(configProvider.upcomingReminder()).fromNow()}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Consumer<AuthenticationProvider>(
                          builder: (_, provider, __) {
                            if (provider.pet == null) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return CircleImageInkWell(
                              image: NetworkImage('${provider.pet.displayPic}'),
                              onPressed: () {},
                              size: 150,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<AuthenticationProvider>(
                          builder: (_, provider, __) {
                            if (provider.pet == null) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Text(
                              '${provider.pet.name}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      Spacer(),
                    ],
                  ],
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).accentColor,
            child: Consumer<AuthenticationProvider>(
              builder: (_, provider, __) {
                return Column(
                  children: [
                    if ((provider.pet != null && provider.pet.petFeed != null)) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(Icons.check_circle, color: Colors.white, size: 75),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Pet Was Fed !',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      // Text(
                      //   '',
                      //   textAlign: TextAlign.center,
                      //   style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                      // ),
                    ] else ...[
                      if (configProvider.hasUpcomingReminder()) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          child: Row(
                            children: [
                              Icon(Icons.notifications_active, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Upcoming Reminder',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              Text(
                                '${Jiffy(configProvider.upcomingReminder()).fromNow()}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                          child: MaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    Pet pet = Provider.of<AuthenticationProvider>(context, listen: false).pet;
                                    AppUser user = Provider.of<AuthenticationProvider>(context, listen: false).appUser;
                                    return ConfirmFeedDialog(configProvider.upcomingReminder(), pet, user);
                                  });
                            },
                            child: Text(
                              'CONFIRM FEED',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            elevation: 0,
                            minWidth: 400,
                            height: 50,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white)),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          child: ListTile(
                            title: Text('No upcoming reminder', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                            leading: Icon(Icons.notifications_active, color: Colors.white),
                            subtitle: Text('i\'ll remind you tomorrow', style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmFeedDialog extends StatelessWidget {
  DateTime dateTime;
  Pet pet;
  AppUser user;

  ConfirmFeedDialog(this.dateTime, this.pet, this.user);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text('Confirm Feed', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text(
              'Are you sure you feed the dog, this will mark your dog has been feed today at ${DateFormat('hh:mm a').format(dateTime)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              children: [
                Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: Text('CLOSE'))),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () async{
                      PetFeed petFeed = PetFeed('${user.id}', DateTime.now().millisecondsSinceEpoch);
                      pet.petFeed = petFeed;
                      await FirestoreHelper.pushPetFeed(pet);
                      Provider.of<AuthenticationProvider>(context, listen: false).setPet(pet);
                      BotToast.showText(text: 'Your pet was marked as Fed!');
                      Navigator.pop(context);
                    },
                    child: Text('CONFIRM'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
