// import 'package:flutter/material.dart';
// import 'package:portfolio/utils/project_utils.dart';

// import '../constants/colors.dart';
// // ignore: deprecated_member_use
// import 'dart:js' as js;

// class ProjectCardWidget extends StatelessWidget {
//   const ProjectCardWidget({
//     super.key,
//     required this.project,
//   });

//   final ProjectUtils project;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 250,
//       width: 230,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         color: Colorss.bgLight2,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image.asset(
//             project.image,
//             fit: BoxFit.fitWidth,
//             height: 140,
//             width: 250,
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
//             child: Text(project.title,style: TextStyle(fontWeight: FontWeight.w600,color: Colorss.whitePrimary),),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//             child: Text(project.subtitle,style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400,color: Colorss.whiteSecondary),),
//           ),
//           Spacer(),
//           Container(
//             color: Colorss.bgLight1,
//             padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
//             child: Row(
//               children: [
//                 Text('Available on:',style: TextStyle(fontSize: 10,color: Colorss.yellowSecondary),),
//                 Spacer(),
//                 if(project.androidLink!=null)
//                 InkWell(
//                   onTap: () {
//                     js.context.callMethod('open', [project.androidLink]);
//                   },
//                   child: Image.asset(
//                     'assets/images/androidd.png',
//                     width: 17,
//                     color: Colorss.whitePrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:portfolio/utils/project_utils.dart';
import '../constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCardWidget extends StatelessWidget {
  const ProjectCardWidget({super.key, required this.project});

  final ProjectUtils project;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 230,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colorss.bgLight2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            project.image,
            fit: BoxFit.fitWidth,
            height: 140,
            width: 250,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
            child: Text(
              project.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colorss.whitePrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              project.subtitle,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colorss.whiteSecondary,
              ),
            ),
          ),
          const Spacer(),
          Container(
            color: Colorss.bgLight1,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Text(
                  'Available on:',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colorss.yellowSecondary,
                  ),
                ),
                const Spacer(),
                if (project.androidLink != null)
                  InkWell(
                    onTap: () {
                      _launchUrl(project.androidLink!);
                    },
                    child: Image.asset(
                      'assets/images/androidd.png',
                      width: 17,
                      color: Colorss.whitePrimary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
