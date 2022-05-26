import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/HomeScreen/menu_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add( Slide(
      title: "Persona Smart Glasses",
      maxLineTitle: 2,
      styleTitle: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      description:"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,",
      styleDescription: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
      backgroundImage: "images/glass.png",
      marginDescription: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      directionColorBegin: Alignment.topLeft,
      directionColorEnd: Alignment.bottomRight,
    ));
    slides.add( Slide(
      title: "Face Recognition",
      maxLineTitle: 2,
      styleTitle: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      description:"Facial recognition is a way of recognizing a human face through technology. A facial recognition system uses biometrics to map facial features from a photograph or video. It compares the information with a database of known faces to find a match.",
      styleDescription: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
      backgroundImage: "images/face.png",
      marginDescription: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      directionColorBegin: Alignment.topLeft,
      directionColorEnd: Alignment.bottomRight,
    ));
    slides.add( Slide(
      title: "Text Recognition",
      maxLineTitle: 2,
      styleTitle: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      description:"It is a widespread technology to recognize text inside images, such as scanned documents and photos. OCR technology is used to convert virtually any kind of image containing written text (typed, handwritten, or printed) into machine-readable text data.",
      styleDescription: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
      backgroundImage: "images/text.png",
      marginDescription: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      directionColorBegin: Alignment.topLeft,
      directionColorEnd: Alignment.bottomRight,
    ));
    slides.add( Slide(
      title: "Text Translation",
      maxLineTitle: 2,
      styleTitle: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      description:"Instead of copying text and paste to translate using mobile, you can take a photo for text you want to translate and persona smart glasses will show you the result with an easily way.",
      styleDescription: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
      backgroundImage: "images/language.png",
      marginDescription: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      directionColorBegin: Alignment.topLeft,
      directionColorEnd: Alignment.bottomRight,
    ));
    slides.add( Slide(
      title: "Memorize",
      maxLineTitle: 2,
      styleTitle: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      description:"Sometimes some people get nervous about presenting their idea in front of a large number of people and forget what he wanted to say so Persona will help you to remember what you wanted to say by memorizing the speech through the ablation and the words will be presented to the persona smart glasses.",
      styleDescription: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
      backgroundImage: "images/present.png",
      marginDescription: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      directionColorBegin: Alignment.topLeft,
      directionColorEnd: Alignment.bottomRight,
    ));
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(bottom: 160, top: 60),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    currentSlide.backgroundImage!,
                    matchTextDirection: true,

                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      currentSlide.title.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      currentSlide.description!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      right: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return IntroSlider(
      slides: slides,
      backgroundColorAllSlides:constantColors.background ,
      renderSkipBtn: const Text("Skip"),
      renderNextBtn: Text("Next", style: TextStyle(color: constantColors.primary),),
      renderDoneBtn: Text("Done", style: TextStyle(color: constantColors.primary),),
      colorDot: Colors.white,
      colorActiveDot: Colors.white,
      sizeDot: 8.0,
      verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      listCustomTabs: renderListCustomTabs(),
      scrollPhysics: const BouncingScrollPhysics(),
      onDonePress: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuScreen(),),
      ),
    );
  }
}
