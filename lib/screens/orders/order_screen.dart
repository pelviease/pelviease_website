import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("My Order");
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pelviease_website/backend/models/order_item_model.dart';
// import 'package:pelviease_website/backend/providers/auth_provider.dart';
// import 'package:pelviease_website/backend/providers/order_item_provider.dart';
// import 'package:pelviease_website/const/theme.dart';
// import 'package:provider/provider.dart';

// class MyOrdersScreen extends StatelessWidget {
//   const MyOrdersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final orderProvider = Provider.of<OrderProvider>(context);

//     return Row(
//       children: [
//         // Profile Sidebar
//         Container(
//           width: 200,
//           color: Color(0xFF6B46C1), // Purple color from image
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Profile',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16),
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.white24,
//                 child: Icon(Icons.person, size: 40, color: Colors.white),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 authProvider.user?.name ?? 'User Name',
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//               Text(
//                 authProvider.user?.email ?? 'email@example.com',
//                 style: TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//               Text(
//                 authProvider.user?.position ?? 'Position',
//                 style: TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle logout
//                   context.go('/login');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: Color(0xFF6B46C1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Logout'),
//               ),
//             ],
//           ),
//         ),
//         // Orders Section
//         Expanded(
//           child: Container(
//             color: Colors.pink[50],
//             padding: EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'My Orders',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Expanded(
//                   child: orderProvider.isLoading
//                       ? Center(child: CircularProgressIndicator())
//                       : orderProvider.errorMessage != null
//                           ? Center(child: Text(orderProvider.errorMessage!))
//                           : ListView.builder(
//                               itemCount: orderProvider.orders.length,
//                               itemBuilder: (context, index) {
//                                 final order = orderProvider.orders[index];
//                                 return OrderCard(order: order);
//                               },
//                             ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final OrderItem order;

//   const OrderCard({super.key, required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: order.status == 'Shipped' ? Colors.white : Colors.pink[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Image.network(
//               order.image,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Icon(
//                   Icons.medical_services,
//                   color: Colors.purple[300],
//                   size: 36,
//                 );
//               },
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   order.name,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(height: 6),
//                 Text(
//                   order.description,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 13,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Qty: 01',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Status: ${order.status}',
//                   style: TextStyle(
//                     color: order.status == 'Shipped' ? Colors.green : Colors.orange,
//                     fontSize: 14,
//                   ),
//                 ),
//                 Text(
//                   'Estimated Delivery: ${order.orderDate.add(Duration(days: 10)).toString().split(' ')[0]}',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle track order
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF6B46C1),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Track Order'),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'TOTAL: ₹ ${order.price.toStringAsFixed(0)}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
