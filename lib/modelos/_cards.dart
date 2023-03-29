import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/contadores.dart';
import 'models.dart';

class LocationCard extends StatelessWidget {
  final double width;
  final List<Locations> locations;
  final int index;
  final Function() onTap;
  const LocationCard({
    super.key,
    required this.width,
    required this.locations,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width,
                height: 100,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!.withOpacity(0.56),
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 1.0,
                          // spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: (locations[index].imagen != null)
                        ? (locations[index].imagen!.contains('shapes'))
                            ? Image.asset(
                                'assets/shapes.png',
                                width: width * 0.9,
                                fit: BoxFit.cover,
                                // height: 100,
                              )
                            : Image.network(
                                locations[index].imagen!,
                                fit: BoxFit.cover,
                                width: width * 0.9,
                              )
                        /* Image(
                                image: NetworkImage(locations[index].imagen!),
                                width: width * 0.9,
                                height: 100,
                              ) */
                        : Image.asset(
                            'assets/shapes.png',
                            width: width * 0.9,
                            fit: BoxFit.cover,
                            // height: 100,
                          ),
                    // const Placeholder(),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.825,
                height: 25,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.825,
                      // height: 25,
                      child: Text(
                        // 'Sede de nombre muy largo y largo y largo y largo y largo y largo',
                        locations[index].nombre,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ContadorBar(
                key: Key(locations[index].location + index.toString()),
                locations: locations,
                background: Colors.white,
                widthT: width * 0.75,
                offset: 0,
                isAppBar: false,
                index: index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
