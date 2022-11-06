import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
var messageChatController = TextEditingController();
class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 23,
                      child: ClipOval(
                        child: Image.network(
                          'https://img.freepik.com/free-photo/portrait-beautiful-smiling-blond-model-dressed-summer-hipster-clothes_158538-5482.jpg?w=826&t=st=1661802184~exp=1661802784~hmac=a2a0c6e168a8508d5dde11aa47ab0f2b8172c8a4f6964c98e51ba4ae59257592',
                          fit: BoxFit.cover,
                          height: 48,
                          width: 48,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),

                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadiusDirectional.only(
                                topEnd: Radius.circular(20),
                                bottomStart: Radius.circular(30),
                                bottomEnd: Radius.circular(20),
                              )),
                          // child: Text('${message.text}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Hallo Man !!', style: TextStyle(height: 1.2)),
                              Text(
                                DateFormat('h:mm a').format(DateTime.now()).toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple[200],
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(20),
                          bottomStart: Radius.circular(20),
                          bottomEnd: Radius.circular(30),
                        )),
                    // child: Text('${message.text}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('im not Man !!', style: TextStyle(height: 1.2)),
                        Text(
                          DateFormat('h:mm a').format(DateTime.now()).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              children: [
                Expanded(
                  //message form field
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0),
                    child: TextFormField(
                      cursorColor: Colors.deepPurple[700],
                      controller: messageChatController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message'),
                    ),
                  ),
                ),
                Container(
                  height: 63,
                  color: Colors.deepPurple[700],
                  child: MaterialButton(
                    minWidth: 1.0,
                    onPressed: () {

                    },
                    child: const Icon(
                      Icons.send_outlined,
                      size: 19,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
