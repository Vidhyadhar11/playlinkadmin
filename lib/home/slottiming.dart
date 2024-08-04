import 'package:flutter/material.dart';

class SlotTimingsPage extends StatefulWidget {
  final List<Map<String, dynamic>> slots;

  const SlotTimingsPage({super.key, required this.slots});

  @override
  _SlotTimingsPageState createState() => _SlotTimingsPageState();
}

class _SlotTimingsPageState extends State<SlotTimingsPage> {
  late List<Map<String, dynamic>> slotRanges;
  List<Map<String, dynamic>> generatedSlots = [];

  @override
  void initState() {
    super.initState();
    slotRanges = widget.slots.map((slot) {
      List<String> times = slot['time'].split(' - ');
      return {
        'startTime': _parseTimeString(times[0]),
        'endTime': _parseTimeString(times[1]),
        'price': slot['price'],
      };
    }).toList();
    generateSlots();
  }

  TimeOfDay _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1].split(' ')[0]);
    if (timeString.toLowerCase().contains('pm') && hour != 12) {
      hour += 12;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  void generateSlots() {
    generatedSlots.clear();
    for (var range in slotRanges) {
      TimeOfDay startTime = range['startTime'];
      TimeOfDay endTime = range['endTime'];
      int price = range['price'];

      while (startTime.hour < endTime.hour || 
             (startTime.hour == endTime.hour && startTime.minute < endTime.minute)) {
        TimeOfDay slotEndTime = TimeOfDay(
          hour: (startTime.hour + 1) % 24,
          minute: startTime.minute,
        );
        
        if (slotEndTime.hour > endTime.hour || 
            (slotEndTime.hour == endTime.hour && slotEndTime.minute > endTime.minute)) {
          slotEndTime = endTime;
        }

        generatedSlots.add({
          'time': '${_formatTimeOfDay(startTime)} - ${_formatTimeOfDay(slotEndTime)}',
          'price': price,
        });

        startTime = slotEndTime;
      }
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slot Timings'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...slotRanges.map((range) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${_formatTimeOfDay(range['startTime'])} - ${_formatTimeOfDay(range['endTime'])}, Price: ${range['price']}', 
                        style: const TextStyle(color: Colors.black)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          slotRanges.remove(range);
                          generateSlots();
                        });
                      },
                    ),
                  ],
                ),
              )).toList(),
              ElevatedButton(
                child: const Text('Add Slot Range'),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TimeOfDay startTime = const TimeOfDay(hour: 7, minute: 0);
                      TimeOfDay endTime = const TimeOfDay(hour: 22, minute: 0);
                      String price = '';
                      return AlertDialog(
                        title: const Text('Add Slot Range'),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        child: Text('Start Time: ${startTime.format(context)}'),
                                        onPressed: () async {
                                          TimeOfDay? picked = await showTimePicker(
                                            context: context,
                                            initialTime: startTime,
                                          );
                                          if (picked != null) setState(() => startTime = picked);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        child: Text('End Time: ${endTime.format(context)}'),
                                        onPressed: () async {
                                          TimeOfDay? picked = await showTimePicker(
                                            context: context,
                                            initialTime: endTime,
                                          );
                                          if (picked != null) setState(() => endTime = picked);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                TextField(
                                  decoration: const InputDecoration(labelText: 'Price per hour'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => price = value,
                                ),
                              ],
                            );
                          }
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Add'),
                            onPressed: () {
                              if (price.isNotEmpty) {
                                setState(() {
                                  slotRanges.add({
                                    'startTime': startTime,
                                    'endTime': endTime,
                                    'price': int.parse(price),
                                  });
                                  generateSlots();
                                });
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('Generated Slots:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ...generatedSlots.map((slot) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text('${slot['time']}, Price: ${slot['price']}', style: const TextStyle(color: Colors.black)),
              )).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save Slots'),
                onPressed: () {
                  Navigator.pop(context, generatedSlots);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}