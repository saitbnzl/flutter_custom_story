import 'package:flutter/material.dart';
import 'package:flutter_kitapsec/pages/home.dart';
import 'package:flutter_kitapsec/pages/story.dart';
import 'package:flutter_kitapsec/pages/card.dart';


final ROUTES = {
  '/': (RouteSettings s) => new HomePage(),
  '/pages/story': (RouteSettings s) => new StoryPage(pushData: s.arguments),
  '/pages/card':(RouteSettings s)=>new MyHomePage(),



};
