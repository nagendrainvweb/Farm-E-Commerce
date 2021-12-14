import 'dart:convert';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/dashboard_data.dart';
import 'package:lotus_farm/model/offerResponse.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/model/state_data.dart';
import 'package:lotus_farm/model/storeData.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/utility.dart';

import '../utils/constants.dart';

class AppRepo extends ChangeNotifier {
  final _apiService = locator<ApiService>();
  bool _isLogin = false;
  bool _introDone = false;

  int _notificationCount = 0;
  int _cartCount = 0;

  DashboardData _dashboardData;
  List<Product> _productList;
  List<Product> _preOrderList;
  List<OffersImg> _offerImgList;
  List<StateData> _stateList = [];
  List<StoreData> _storeList = [];

  bool get login => _isLogin;
  int get notificationCount => _notificationCount;
  int get cartCount => _cartCount;
  bool get introDone => _introDone;
  DashboardData get dashboardData => _dashboardData;
  List<Product> get productList => _productList;
  List<Product> get preOrderList => _preOrderList;
  List<OffersImg> get offerList => _offerImgList;
  List<StateData> get stateList => _stateList;
  List<StoreData> get storeList => _storeList;

  String _termsCondition = "<html><body><div>" +
      '<p>These Terms of Service (“Agreement”) apply to the use of website – www.lotusfarms.in ("Website"), the Lotus Farms mobile application on iOS or Android devices including phones, tablets or any other electronic device ("Lotus Farms App"). The Website and mobile App are together referred to as the "Platform".</p>' +
      '<p><strong><u>ACCEPTANCE</u></strong></p>' +
      '<p>LOTUS FARMS encourages you to review this Agreement whenever you visit the Platform to make sure that you understand the terms and conditions governing the use of the Platform and / or the purchase of Products (<em>defined below</em>). This Agreement does not alter in any way the terms or conditions of any other written agreement you may have with LOTUS FARMS for other products or services. In the event of any conflict between the terms of this Agreement and any other agreement executed with you, the terms of such other agreement shall prevail in relation to the subject matter thereof.</p>' +
      '<p>If you do not agree with this Agreement (including any policies or guidelines referred to herein), please immediately terminate your use of the Platform. If you would like to print this Agreement, please click the print button on your browser toolbar.</p>' +
      '<p><strong><u>ELIGIBILITY</u></strong></p>' +
      '<p>You hereby represent and warrant that you are at least eighteen (18) years of age or above and are fully able and competent to understand and agree to the terms and conditions set forth in this Agreement.</p>' +
      '<p>LOTUS FARMS reserves the right to terminate your membership and/or refuse access to the Platform, if you are below eighteen (18) years of age or otherwise incompetent to contract as per applicable law.</p>' +
      '<p><strong><u>TERMS OF USE</u></strong></p>' +
      '<p>We grant you a limited, non-exclusive, non-transferable, and revocable license to use our Platform, subject to the terms of this Agreement. You agree that you will not violate any laws in connection with your use of the Platform or interfere with or try to disrupt the Platform.\nYou understand and accept that all information, data, text, software, music, sound, photographs, graphics, audio, video, message or other material appearing on the Platform including the brand name – Lotus Farms (collectively, “Content”) are owned by LOTUS FARMS or it\'s licensors. You are expressly prohibited from using any Content without the express written consent of LOTUS FARMS or it\'s licensors. Except as otherwise stated in this Agreement, none of the Content may be reproduced, distributed, republished, downloaded, displayed, posted, transmitted, or copied in any form or by any means, without the prior written permission of LOTUS FARMS, and/or the appropriate licensor. Permission is granted to display, copy, distribute, and download the materials on the Platform solely for your personal, non-commercial use provided that you make no modifications to the materials and that all copyright and other proprietary notices contained in the materials are retained. You may not, without LOTUS FARMS’s express written permission, \'mirror\' any material contained on the Platform or any other server. Any permission granted under this Agreement terminates automatically without further notice if you breach any of the above terms. Upon such termination, you agree to immediately destroy any downloaded and/or printed Content.\nYou shall not host, display, upload, modify, publish, transmit, update or share any information on the Platform that —</p>' +
      '<ol>' +
      '<li>belongs to another person and to which you do not have any right to;</li>' +
      '<li>is grossly harmful, harassing, blasphemous defamatory, obscene, pornographic, pedophilic, libelous, invasive of another\'s privacy, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, or otherwise unlawful in any manner whatever;</li>' +
      '<li>harm minors in any way;</li>' +
      '<li>infringes any patent, trademark, copyright or other proprietary rights;</li>' +
      '<li>violates any law for the time being in force;</li>' +
      '<li>deceives or misleads the addressee about the origin of such messages or communicates any information which is grossly offensive or menacing in nature;</li>' +
      '<li>impersonates another person;</li>' +
      '<li>contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of the Platform;</li>' +
      '<li>threatens the unity, integrity, defence, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognizable offence or prevents investigation of any offence or is insulting any other nation.</li>' +
      '</ol>' +
      '<p>You agree not to collect information of other users from the Platform or download or copy any information by means of unsolicited access so as to communicate directly with them or for any reason whatsoever.</p>' +
      '<p>ANY USE OF THE PLATFORM NOT SPECIFICALLY PERMITTED UNDER THIS AGREEMENT IS STRICTLY PROHIBITED.</p>' +
      '<p><strong><u>PRODUCTS, ORDERING AND PRICING</u></strong></p>' +
      '<p>LOTUS FARMS is currently delivering orders of the products listed on the Platform (“Products”) and providing various offers mentioned on the Platform (“Offers”) only in Bengaluru. We will not be able to service orders at any place other than the Operating Locations. Any modification in the Operating Locations of LOTUS FARMS shall be mentioned on the Platform.</p>' +
      '<p>All Products are subject to availability and we reserve the right to impose quantity limits on any order, to reject all or part of an order, and to discontinue Products without notice, even if you have already placed an order.</p>' +
      '<p>We take care to accurately display the description, colors and images of our Products but, we cannot guarantee nor take responsibility for variations in pictorial representations for the Products and color variation due to technical reasons. Prices and descriptions of the Products are subject to change at any time without notice, at our sole discretion.</p>' +
      '<p>We shall not be liable to you or to any third-party for any modification in price, suspension or discontinuance of the Products.</p>' +
      '<p>The Platform allows you to place order for Products in standard quantities and the price of each Product displayed on the Platform is also calculated on the basis of standard quantity of the Product. However, due to the nature of the Product there may be a variance between the quantity ordered and the quantity supplied.</p>' +
      '<p>We will only charge you for the quantity of the Product that has been supplied to you. In case the quantity of the Product supplied to you is less than the quantity of Product ordered, any excess amounts paid by you shall be refunded to you. The mode of refund shall be as determined by LOTUS FARMS from time to time, such as, credit to Lotus Farms wallet, Lotus Farms Cash +, or by crediting any other mobile wallet that you may use.</p>' +
      '<p>In case the quantity of the Product supplied to you exceeds the quantity ordered by you, any additional amount due from you will be adjusted against your next order.</p>' +
      '<p>The Products sold on the Platform are perishable goods. Hence, we recommend that you read the instructions written on the packaging of each Product carefully, before using such Product.</p>' +
      '<p>Any offers available on the Platform shall be, in addition to this Agreement, subject to the terms and conditions as may be listed on the Platform in relation to such offers.</p>' +
      '<p>LOTUS FARMS has proprietary rights and trade secrets in the Products. You shall not copy, reproduce, resell or redistribute any Product manufactured and/or distributed by LOTUS FARMS.</p>' +
      '<p><strong><u>DELIVERY, HANDLING CHARGES AND TAXES</u></strong></p>' +
      '<p>LOTUS FARMS may charge such delivery and handling charges, as maybe determined by LOTUS FARMS from time to time along with the applicable taxes.</p>' +
      '<p>Although LOTUS FARMS strives to deliver the orders on time, there may be situations wherein the actual time taken for delivery of a Product shall vary from the delivery time mentioned at the time of ordering such Product. LOTUS FARMS shall keep you updated about any delays in delivering of Products.</p>' +
      '<p>&nbsp;</p>' +
      '<p>&nbsp;</p>' +
      '<p><strong><u>PLATFORM</u></strong></p>' +
      '<p><strong>Intellectual Property and Third-Party Links</strong></p>' +
      '<p>LOTUS FARMS is the owner of the brand Lotus Farms and the Platform and has the exclusive right, title and ownership of any and all intellectual property rights arising out of it\'s brand and the Platform.</p>' +
      '<p>LOTUS FARMS may occasionally post links to third party websites or other services on the Platform. You agree that LOTUS FARMS is not responsible or liable for any loss or damage caused as a result of your use of any third-party services linked to from the Platform.</p>' +
      '<p>In addition to making Products available, this Platform also offers information, both directly and through third-party links, about nutritional and dietary supplements. Such information available on the Platform is for general use and you may rely on it solely at your own risk. We will not be liable for any direct, indirect, consequential or other damages arising out of or connected with the use of this information. Further, for any third-party content displayed or accessed through the Platform the sole responsibility for such content is of the person/entity who makes it available.</p>' +
      '<p><strong>User Account</strong></p>' +
      '<p>To access and use the Platform, you may register with us by providing the required information. You are responsible for ensuring the accuracy of this information.</p>' +
      '<p>You are responsible for keeping your password secure. We cannot and will not be liable for any loss or damage from your failure to maintain the security of your account and password. The billing information you provide us, including payment details, billing address and other payment information, is subject to the same accuracy requirements as the rest of your identifying information. Providing false or inaccurate information or using the Platform to further fraud or any unlawful activity is grounds for immediate termination of this Agreement.</p>' +
      '<p>By posting, storing, or transmitting any content on the Platform, you hereby grant LOTUS FARMS a perpetual, worldwide, non-exclusive, royalty-free, assignable, right and license to use, copy, display, perform, create derivative works from, distribute, have distributed, transmit and assign such content in any form, in all media now known or hereinafter created, anywhere in the world. LOTUS FARMSdoes not have the ability to control the nature of the user-generated content offered through the Platform. You are solely responsible for your interactions with other users of the Platform and any content you post. LOTUS FARMS is not liable for any damage or harm resulting from any posts by or interactions between users. LOTUS FARMS reserves the right, but has no obligation, to monitor interactions between and among users of the Platform and to remove any content LOTUS FARMS deems objectionable, at it\'s sole discretion.</p>' +
      '<p><strong>Reverse Engineering &amp; Security</strong></p>' +
      '<p>You agree not to undertake any of the following actions:</p>' +
      '<ol>' +
      '<li>Reverse engineer, or attempt to reverse engineer or disassemble any code or software from or on the Platform;</li>' +
      '<li>Violate the security of the Platform through any unauthorized access, circumvention of encryption or other security tools, data mining or interference to any host, user or network; and</li>' +
      '<li>Use the Platform for illegal spam activities, including gathering email addresses and personal information from others or sending any mass commercial emails.</li>' +
      '</ol>' +
      '<p><strong>Customer Solicitation</strong></p>' +
      '<p>Unless you notify us in writing, of your intention to opt out from further direct and indirect marketing communications and solicitations, you are agreeing to continue to receive emails, calls and messages through different mediums for soliciting Products.</p>' +
      '<p><strong>Opt Out Procedure</strong></p>' +
      '<p>You may choose to opt out from receiving future marketing and solicitation communications by following the steps below.</p>' +
      '<p>&nbsp;</p>' +
      '<p><strong><u>DISCLAIMER OF WARRANTIES</u></strong></p>' +
      '<p>Your use of this Platform is at your sole risk. The Platform, Products and offers are offered on an "as is" and "as available" basis. To the extent permitted under applicable laws, LOTUS FARMS expressly disclaims all warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose and non-infringement with respect to the Products or Platform, or any reliance upon or use of the Platform or Products.</p>' +
      '<p>Without limiting the generality of the foregoing, LOTUS FARMS makes no warranty that the content and the links to third-party platforms provided on this Platform are accurate, reliable, complete, or timely.</p>' +
      '<p>No advice or information, whether oral or written, obtained by you from this Platform will create any warranty, not expressly stated herein, as to the results that may be obtained from the use of the Products or that any defects in the Products will be corrected.</p>' +
      '<p><strong><u>LIMITATION OF LIABILITY</u></strong></p>' +
      '<p>The entire liability of LOTUS FARMS and your exclusive remedy, in law, in equity, or otherwise, with respect to the use of Platform, Products, offers and/or for any breach of this Agreement is solely limited to the amount you paid in last one month from any such claim arising, less shipping and handling costs and taxes, for Products purchased via the Platform.</p>' +
      '<p>To the extent permitted under applicable laws, LOTUS FARMS will not be liable for any direct, indirect, incidental, special or consequential damages in connection with this Agreement or the use of Platform, Products and offers in any manner, including liabilities resulting from (1) the use or the inability to use the Platform, Products or offers; (2) the cost of procuring substitute Products; or (3) any lost profits, loss of goodwill, loss, theft or corruption of user information that you may allege.</p>' +
      '<p><strong><u>INDEMNIFICATION</u></strong></p>' +
      '<p>You will release, indemnify, defend and hold harmless LOTUS FARMS and any of it\'s contractors, agents, employees, officers, directors, shareholders, affiliates and assigns from all liabilities, claims, damages, costs and expenses, including reasonable attorneys\' fees and expenses, of third parties relating to or arising out of (1) your violation of any provision of this Agreement including the breach of your warranties, representations and obligations under this Agreement by you; (2) your use of the Platform, Products or offers; (3) infringement of any intellectual property or other proprietary right of any person or entity including LOTUS FARMS by you; or (4) any information or data supplied to LOTUS FARMS by you. When LOTUS FARMS is threatened with suit or sued by a third party, LOTUS FARMS may seek written assurances from you concerning your promise to indemnify LOTUS FARMS; your failure to provide such assurances may be considered by LOTUS FARMS to be a material breach of this Agreement. LOTUS FARMS will have the right to participate in any defence by you of a third-party claim related to your use of the Platform, Products or offers, with a counsel of LOTUS FARMS’s choice at its expense. LOTUS FARMS will reasonably cooperate in any defence by you of a third-party claim at your request and expense. You will have sole responsibility to defend LOTUS FARMS against any claim, but you must receive LOTUS FARMS prior written consent regarding any related settlement. The terms of this provision will survive any termination or cancellation of this Agreement or your use of the Platform or Products.</p>' +
      '<p><strong><u>MODIFICATION</u></strong></p>' +
      '<p>LOTUS FARMS reserves the right to amend this Agreement at any time, in accordance with applicable law, by posting such amendments or the amended Agreement on this Platform.</p>' +
      '<p>LOTUS FARMS may alert you of the amendments by indicating on the top of this Agreement the date it was last revised or by any other means. The amended Agreement will be effective immediately after it is posted on this Platform. Your use of the Platform following the posting of any such amendments will constitute continued acceptance of the Agreement including the amendments thereof.</p>' +
      '<p><strong><u>PRIVACY</u></strong></p>' +
      '<p>LOTUS FARMS believes strongly in protecting user privacy and providing you with notice of use of your data. Please refer to LOTUS FARMS’s&nbsp;<a href="https://www.licious.in/privacy-policy">Privacy Policy</a>, incorporated herein by reference.</p>' +
      '<p><strong><u>GENERAL</u></strong></p>' +
      '<p><strong>Force Majeure</strong></p>' +
      '<p>LOTUS FARMS will not be deemed in default hereunder or held responsible for any cessation, interruption or delay in the performance of it\'s obligations hereunder due to earthquake, flood, fire, storm, natural disaster, act of God, war, terrorism, pandemic, lockdown conditions, armed conflict, labor strike, lockout, or boycott.</p>' +
      '<p><strong>Cessation of Operation</strong></p>' +
      '<p>LOTUS FARMS may at any time, in it\'s sole discretion and without advance notice, stop the operation of the Platform and/or distribution of the Products and/or the offers provided on the Platform.</p>' +
      '<p><strong>Entire Agreement</strong></p>' +
      '<p>This Agreement including the policies and guidelines included herein by reference comprise the entire agreement between you and LOTUS FARMS and supersedes any prior agreements pertaining to the subject matter contained herein.</p>' +
      '<p><strong>Effect of Waiver</strong></p>' +
      '<p>The failure of LOTUS FARMS to exercise or enforce any right or provision of this Agreement will not constitute a waiver of such right or provision. If any provision of this Agreement is found by a court of competent jurisdiction to be invalid, the parties nevertheless agree that the court should endeavour to give effect to the parties\' intentions as reflected in the provision, and the other provisions of this Agreement remain in full force and effect.</p>' +
      '<p><strong>Governing Law and Jurisdiction</strong></p>' +
      '<p>This Agreement will be governed by the laws of India and shall be subject to the exclusive jurisdiction of courts in Bangalore, Karnataka.</p>' +
      '<p><strong>Dispute Resolution</strong></p>' +
      '<p>If any dispute arises between you and LOTUS FARMS during your use of the Platform or thereafter, the dispute shall be referred to a sole arbitrator, who shall be appointed by an independent and neutral third party arbitral institution identified by LOTUS FARMS. The place of arbitration shall be Bengaluru, Karnataka. The arbitration proceedings shall be in the English language and shall be governed by Arbitration &amp; Conciliation Act, 1996.</p>' +
      '<p>This arbitration agreement will survive the termination of this Agreement with you.</p>' +
      '<p><strong>Waiver of Class Action Rights</strong></p>' +
      '<p>By entering into this Agreement, you hereby irrevocably waive any right you may have to join claims with those of other in the form of a class action or similar procedural device. Any claims arising out of, relating to, or connection with this agreement must be asserted individually.</p>' +
      '<p><strong>Termination</strong></p>' +
      '<p>LOTUS FARMS reserves the right to terminate your access to the Platform without advance notice if it reasonably believes, in it\'s sole discretion, that you have breached any of the terms and conditions of this Agreement. Following termination, you will not be permitted to use the Platform and LOTUS FARMS may, in it\'s sole discretion and without advance notice to you, cancel any outstanding orders for Products. If your access to the Platform is terminated, LOTUS FARMS reserves the right to exercise whatever means it deems necessary to prevent unauthorized access of the Platform. This Agreement will survive indefinitely unless and until LOTUS FARMS chooses, in it\'s sole discretion and without advance notice to you, to terminate it.</p>' +
      '<p><strong>Use of Platform outside Operating Locations</strong></p>' +
      '<p>LOTUS FARMS makes no representation that the Platform or Products or offers are appropriate or available for use in locations other than the Operating Locations.</p>' +
      '<p><strong>Assignment</strong></p>' +
      '<p>You may not assign your rights and obligations under this Agreement to anyone. LOTUS FARMS may in accordance with applicable law assign it\'s rights and obligations under this Agreement in it\'s sole discretion and without advance notice to you.</p>' +
      '<p><strong>Severability</strong></p>' +
      '<p>In the event that any provision of this Agreement is determined to be unlawful, void or unenforceable, such provision shall nonetheless be enforceable to the fullest extent permitted by applicable law, and the unenforceable portion shall be deemed to be severed from the Agreement, such determination shall not affect the validity and enforceability of any other remaining provisions.</p>' +
      '<p><strong>Conflict</strong></p>' +
      '<p>This Agreement includes, and incorporates by reference, the&nbsp;<a href="https://www.licious.in/privacy-policy">Privacy Policy</a>&nbsp;and any other rules or policies available on the Platform including all other additional or modified terms and conditions and policies in relation to the Platform or any current or future services that may be offered by LOTUS FARMS. In the event of any conflict between the terms of this Agreement and any provision of the polices and guidelines available on the Platform, the terms of this Agreement shall prevail in relation to the subject matter hereof and the terms of such polices and guidelines shall prevail in relation to the subject matter thereof. You are strongly advised to carefully read all such policies and guidelines, as available on the Platform.</p>' +
      '<p><strong>Contact Us</strong></p>' +
      '<p>Please contact us for any questions or comments (including all inquiries unrelated to copyright infringement) regarding this Platform.</p>' +
      '<p>This document is an electronic record in terms of Information Technology Act, 2000 and rules there under as applicable and the amended provisions pertaining to electronic records in various statutes as amended by the Information Technology Act, 2000. This electronic record is generated by a computer system and does not require any physical or digital signatures.</p>' +
      '<p>&nbsp;</p>' +
      '<p>These Terms of Service (“Agreement”) apply to the use of website – www.lotusfarms.in ("Website"), the Lotus Farms mobile application on iOS or Android devices including phones, tablets or any other electronic device ("Lotus Farms App"). The Website and mobile App are together referred to as the "Platform".</p>' +
      '<p>For the purposes of this Agreement, wherever the context so requires "you" or "User" shall mean any person including any natural or legal person who uses the Platform or buys any product of LOTUS FARMS using any computer system or other device including but not limited to any mobile device, handheld device and tablet and “we” shall mean Lotus Farms.</p>' +
      '<p><strong><u>ACCEPTANCE</u></strong></p>' +
      '<p>LOTUS FARMS encourages you to review this Agreement whenever you visit the Platform to make sure that you understand the terms and conditions governing the use of the Platform and / or the purchase of Products (<em>defined below</em>). This Agreement does not alter in any way the terms or conditions of any other written agreement you may have with LOTUS FARMS for other products or services. In the event of any conflict between the terms of this Agreement and any other agreement executed with you, the terms of such other agreement shall prevail in relation to the subject matter thereof.</p>' +
      '<p>If you do not agree with this Agreement (including any policies or guidelines referred to herein), please immediately terminate your use of the Platform. If you would like to print this Agreement, please click the print button on your browser toolbar.</p>' +
      '<p><strong><u>ELIGIBILITY</u></strong></p>' +
      '<p>You hereby represent and warrant that you are at least eighteen (18) years of age or above and are fully able and competent to understand and agree to the terms and conditions set forth in this Agreement.</p>' +
      '<p>LOTUS FARMS reserves the right to terminate your membership and/or refuse access to the Platform, if you are below eighteen (18) years of age or otherwise incompetent to contract as per applicable law.</p>' +
      '<p><strong><u>TERMS OF USE</u></strong></p>' +
      '<p>We grant you a limited, non-exclusive, non-transferable, and revocable license to use our Platform, subject to the terms of this Agreement. You agree that you will not violate any laws in connection with your use of the Platform or interfere with or try to disrupt the Platform.</p>' +
      '<p>You understand and accept that all information, data, text, software, music, sound, photographs, graphics, audio, video, message or other material appearing on the Platform including the brand name – Lotus Farms (collectively, “Content”) are owned by LOTUS FARMS or it\'s licensors. You are expressly prohibited from using any Content without the express written consent of LOTUS FARMS or it\'s licensors. Except as otherwise stated in this Agreement, none of the Content may be reproduced, distributed, republished, downloaded, displayed, posted, transmitted, or copied in any form or by any means, without the prior written permission of LOTUS FARMS, and/or the appropriate licensor. Permission is granted to display, copy, distribute, and download the materials on the Platform solely for your personal, non-commercial use provided that you make no modifications to the materials and that all copyright and other proprietary notices contained in the materials are retained. You may not, without LOTUS FARMS’s express written permission, \'mirror\' any material contained on the Platform or any other server. Any permission granted under this Agreement terminates automatically without further notice if you breach any of the above terms. Upon such termination, you agree to immediately destroy any downloaded and/or printed Content.</p>' +
      '<p>You shall not host, display, upload, modify, publish, transmit, update or share any information on the Platform that —</p>' +
      '<ol>' +
      '<li>belongs to another person and to which you do not have any right to;</li>' +
      '<li>is grossly harmful, harassing, blasphemous defamatory, obscene, pornographic, pedophilic, libelous, invasive of another\'s privacy, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, or otherwise unlawful in any manner whatever;</li>' +
      '<li>harm minors in any way;</li>' +
      '<li>infringes any patent, trademark, copyright or other proprietary rights;</li>' +
      '<li>violates any law for the time being in force;</li>' +
      '<li>deceives or misleads the addressee about the origin of such messages or communicates any information which is grossly offensive or menacing in nature;</li>' +
      '<li>impersonates another person;</li>' +
      '<li>contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of the Platform;</li>' +
      '<li>threatens the unity, integrity, defence, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognizable offence or prevents investigation of any offence or is insulting any other nation.</li>' +
      '</ol>' +
      '<p>You agree not to collect information of other users from the Platform or download or copy any information by means of unsolicited access so as to communicate directly with them or for any reason whatsoever.</p>' +
      '<p>ANY USE OF THE PLATFORM NOT SPECIFICALLY PERMITTED UNDER THIS AGREEMENT IS STRICTLY PROHIBITED.</p>' +
      '<p><strong><u>PRODUCTS, ORDERING AND PRICING</u></strong></p>' +
      '<p>LOTUS FARMS is currently delivering orders of the products listed on the Platform (“Products”) and providing various offers mentioned on the Platform (“Offers”) only in Bengaluru. We will not be able to service orders at any place other than the Operating Locations. Any modification in the Operating Locations of LOTUS FARMS shall be mentioned on the Platform.</p>' +
      '<p>All Products are subject to availability and we reserve the right to impose quantity limits on any order, to reject all or part of an order, and to discontinue Products without notice, even if you have already placed an order.</p>' +
      '<p>We take care to accurately display the description, colors and images of our Products but, we cannot guarantee nor take responsibility for variations in pictorial representations for the Products and color variation due to technical reasons. Prices and descriptions of the Products are subject to change at any time without notice, at our sole discretion.</p>' +
      '<p>We shall not be liable to you or to any third-party for any modification in price, suspension or discontinuance of the Products.</p>' +
      '<p>The Platform allows you to place order for Products in standard quantities and the price of each Product displayed on the Platform is also calculated on the basis of standard quantity of the Product. However, due to the nature of the Product there may be a variance between the quantity ordered and the quantity supplied.</p>' +
      '<p>We will only charge you for the quantity of the Product that has been supplied to you. In case the quantity of the Product supplied to you is less than the quantity of Product ordered, any excess amounts paid by you shall be refunded to you. The mode of refund shall be as determined by LOTUS FARMS from time to time, such as, credit to Lotus Farms wallet, Lotus Farms Cash +, or by crediting any other mobile wallet that you may use.</p>' +
      '<p>In case the quantity of the Product supplied to you exceeds the quantity ordered by you, any additional amount due from you will be adjusted against your next order.</p>' +
      '<p>The Products sold on the Platform are perishable goods. Hence, we recommend that you read the instructions written on the packaging of each Product carefully, before using such Product.</p>' +
      '<p>Any offers available on the Platform shall be, in addition to this Agreement, subject to the terms and conditions as may be listed on the Platform in relation to such offers.</p>' +
      '<p>LOTUS FARMS has proprietary rights and trade secrets in the Products. You shall not copy, reproduce, resell or redistribute any Product manufactured and/or distributed by LOTUS FARMS.</p>' +
      '<p><strong><u>DELIVERY, HANDLING CHARGES AND TAXES</u></strong></p>' +
      '<p>LOTUS FARMS may charge such delivery and handling charges, as maybe determined by LOTUS FARMS from time to time along with the applicable taxes.</p>' +
      '<p>Although LOTUS FARMS strives to deliver the orders on time, there may be situations wherein the actual time taken for delivery of a Product shall vary from the delivery time mentioned at the time of ordering such Product. LOTUS FARMS shall keep you updated about any delays in delivering of Products.</p>' +
      '<p>&nbsp;</p>' +
      '<p>&nbsp;</p>' +
      '<p><strong><u>PLATFORM</u></strong></p>' +
      '<p><strong>Intellectual Property and Third-Party Links</strong></p>' +
      '<p>LOTUS FARMS is the owner of the brand Lotus Farms and the Platform and has the exclusive right, title and ownership of any and all intellectual property rights arising out of it\'s brand and the Platform.</p>' +
      '<p>LOTUS FARMS may occasionally post links to third party websites or other services on the Platform. You agree that LOTUS FARMS is not responsible or liable for any loss or damage caused as a result of your use of any third-party services linked to from the Platform.</p>' +
      '<p>In addition to making Products available, this Platform also offers information, both directly and through third-party links, about nutritional and dietary supplements. Such information available on the Platform is for general use and you may rely on it solely at your own risk. We will not be liable for any direct, indirect, consequential or other damages arising out of or connected with the use of this information. Further, for any third-party content displayed or accessed through the Platform the sole responsibility for such content is of the person/entity who makes it available.</p>' +
      '<p><strong>User Account</strong></p>' +
      '<p>To access and use the Platform, you may register with us by providing the required information. You are responsible for ensuring the accuracy of this information.</p>' +
      '<p>You are responsible for keeping your password secure. We cannot and will not be liable for any loss or damage from your failure to maintain the security of your account and password. The billing information you provide us, including payment details, billing address and other payment information, is subject to the same accuracy requirements as the rest of your identifying information. Providing false or inaccurate information or using the Platform to further fraud or any unlawful activity is grounds for immediate termination of this Agreement.</p>' +
      '<p>By posting, storing, or transmitting any content on the Platform, you hereby grant LOTUS FARMS a perpetual, worldwide, non-exclusive, royalty-free, assignable, right and license to use, copy, display, perform, create derivative works from, distribute, have distributed, transmit and assign such content in any form, in all media now known or hereinafter created, anywhere in the world. LOTUS FARMSdoes not have the ability to control the nature of the user-generated content offered through the Platform. You are solely responsible for your interactions with other users of the Platform and any content you post. LOTUS FARMS is not liable for any damage or harm resulting from any posts by or interactions between users. LOTUS FARMS reserves the right, but has no obligation, to monitor interactions between and among users of the Platform and to remove any content LOTUS FARMS deems objectionable, at it\'s sole discretion.</p>' +
      '<p><strong>Reverse Engineering &amp; Security</strong></p>' +
      '<p>You agree not to undertake any of the following actions:</p>' +
      '<ol>' +
      '<li>Reverse engineer, or attempt to reverse engineer or disassemble any code or software from or on the Platform;</li>' +
      '<li>Violate the security of the Platform through any unauthorized access, circumvention of encryption or other security tools, data mining or interference to any host, user or network; and</li>' +
      '<li>Use the Platform for illegal spam activities, including gathering email addresses and personal information from others or sending any mass commercial emails.</li>' +
      '</ol>' +
      '<p><strong>Customer Solicitation</strong></p>' +
      '<p>Unless you notify us in writing, of your intention to opt out from further direct and indirect marketing communications and solicitations, you are agreeing to continue to receive emails, calls and messages through different mediums for soliciting Products.</p>' +
      '<p><strong>Opt Out Procedure</strong></p>' +
      '<p>You may choose to opt out from receiving future marketing and solicitation communications by following the steps below.</p>' +
      '<p>&nbsp;</p>' +
      '<p><strong><u>DISCLAIMER OF WARRANTIES</u></strong></p>' +
      '<p>Your use of this Platform is at your sole risk. The Platform, Products and offers are offered on an "as is" and "as available" basis. To the extent permitted under applicable laws, LOTUS FARMS expressly disclaims all warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose and non-infringement with respect to the Products or Platform, or any reliance upon or use of the Platform or Products.</p>' +
      '<p>Without limiting the generality of the foregoing, LOTUS FARMS makes no warranty that the content and the links to third-party platforms provided on this Platform are accurate, reliable, complete, or timely.</p>' +
      '<p>No advice or information, whether oral or written, obtained by you from this Platform will create any warranty, not expressly stated herein, as to the results that may be obtained from the use of the Products or that any defects in the Products will be corrected.</p>' +
      '<p><strong><u>LIMITATION OF LIABILITY</u></strong></p>' +
      '<p>The entire liability of LOTUS FARMS and your exclusive remedy, in law, in equity, or otherwise, with respect to the use of Platform, Products, offers and/or for any breach of this Agreement is solely limited to the amount you paid in last one month from any such claim arising, less shipping and handling costs and taxes, for Products purchased via the Platform.</p>' +
      '<p>To the extent permitted under applicable laws, LOTUS FARMS will not be liable for any direct, indirect, incidental, special or consequential damages in connection with this Agreement or the use of Platform, Products and offers in any manner, including liabilities resulting from (1) the use or the inability to use the Platform, Products or offers; (2) the cost of procuring substitute Products; or (3) any lost profits, loss of goodwill, loss, theft or corruption of user information that you may allege.</p>' +
      '<p><strong><u>INDEMNIFICATION</u></strong></p>' +
      '<p>You will release, indemnify, defend and hold harmless LOTUS FARMS and any of it\'s contractors, agents, employees, officers, directors, shareholders, affiliates and assigns from all liabilities, claims, damages, costs and expenses, including reasonable attorneys fees and expenses, of third parties relating to or arising out of (1) your violation of any provision of this Agreement including the breach of your warranties, representations and obligations under this Agreement by you; (2) your use of the Platform, Products or offers; (3) infringement of any intellectual property or other proprietary right of any person or entity including LOTUS FARMS by you; or (4) any information or data supplied to LOTUS FARMS by you. When LOTUS FARMS is threatened with suit or sued by a third party, LOTUS FARMS may seek written assurances from you concerning your promise to indemnify LOTUS FARMS; your failure to provide such assurances may be considered by LOTUS FARMS to be a material breach of this Agreement. LOTUS FARMS will have the right to participate in any defence by you of a third-party claim related to your use of the Platform, Products or offers, with a counsel of LOTUS FARMS’s choice at its expense. LOTUS FARMS will reasonably cooperate in any defence by you of a third-party claim at your request and expense. You will have sole responsibility to defend LOTUS FARMS against any claim, but you must receive LOTUS FARMS prior written consent regarding any related settlement. The terms of this provision will survive any termination or cancellation of this Agreement or your use of the Platform or Products.</p>' +
      '<p><strong><u>MODIFICATION</u></strong></p>' +
      '<p>LOTUS FARMS reserves the right to amend this Agreement at any time, in accordance with applicable law, by posting such amendments or the amended Agreement on this Platform.</p>' +
      '<p>LOTUS FARMS may alert you of the amendments by indicating on the top of this Agreement the date it was last revised or by any other means. The amended Agreement will be effective immediately after it is posted on this Platform. Your use of the Platform following the posting of any such amendments will constitute continued acceptance of the Agreement including the amendments thereof.</p>' +
      '<p><strong><u>PRIVACY</u></strong></p>' +
      '<p>LOTUS FARMS believes strongly in protecting user privacy and providing you with notice of use of your data. Please refer to LOTUS FARMS’s&nbsp;<a href="https://www.licious.in/privacy-policy">Privacy Policy</a>, incorporated herein by reference.</p>' +
      '<p><strong><u>GENERAL</u></strong></p>' +
      '<p><strong>Force Majeure</strong></p>' +
      '<p>LOTUS FARMS will not be deemed in default hereunder or held responsible for any cessation, interruption or delay in the performance of it\'s obligations hereunder due to earthquake, flood, fire, storm, natural disaster, act of God, war, terrorism, pandemic, lockdown conditions, armed conflict, labor strike, lockout, or boycott.</p>' +
      '<p><strong>Cessation of Operation</strong></p>' +
      '<p>LOTUS FARMS may at any time, in it\'s sole discretion and without advance notice, stop the operation of the Platform and/or distribution of the Products and/or the offers provided on the Platform.</p>' +
      '<p><strong>Entire Agreement</strong></p>' +
      '<p>This Agreement including the policies and guidelines included herein by reference comprise the entire agreement between you and LOTUS FARMS and supersedes any prior agreements pertaining to the subject matter contained herein.</p>' +
      '<p><strong>Effect of Waiver</strong></p>' +
      '<p>The failure of LOTUS FARMS to exercise or enforce any right or provision of this Agreement will not constitute a waiver of such right or provision. If any provision of this Agreement is found by a court of competent jurisdiction to be invalid, the parties nevertheless agree that the court should endeavour to give effect to the parties\' intentions as reflected in the provision, and the other provisions of this Agreement remain in full force and effect.</p>' +
      '<p><strong>Governing Law and Jurisdiction</strong></p>' +
      '<p>This Agreement will be governed by the laws of India and shall be subject to the exclusive jurisdiction of courts in Bangalore, Karnataka.</p>' +
      '<p><strong>Dispute Resolution</strong></p>' +
      '<p>If any dispute arises between you and LOTUS FARMS during your use of the Platform or thereafter, the dispute shall be referred to a sole arbitrator, who shall be appointed by an independent and neutral third party arbitral institution identified by LOTUS FARMS. The place of arbitration shall be Bengaluru, Karnataka. The arbitration proceedings shall be in the English language and shall be governed by Arbitration &amp; Conciliation Act, 1996.</p>' +
      '<p>This arbitration agreement will survive the termination of this Agreement with you.</p>' +
      '<p><strong>Waiver of Class Action Rights</strong></p>' +
      '<p>By entering into this Agreement, you hereby irrevocably waive any right you may have to join claims with those of other in the form of a class action or similar procedural device. Any claims arising out of, relating to, or connection with this agreement must be asserted individually.</p>' +
      '<p><strong>Termination</strong></p>' +
      '<p>LOTUS FARMS reserves the right to terminate your access to the Platform without advance notice if it reasonably believes, in it\'s sole discretion, that you have breached any of the terms and conditions of this Agreement. Following termination, you will not be permitted to use the Platform and LOTUS FARMS may, in it\'s sole discretion and without advance notice to you, cancel any outstanding orders for Products. If your access to the Platform is terminated, LOTUS FARMS reserves the right to exercise whatever means it deems necessary to prevent unauthorized access of the Platform. This Agreement will survive indefinitely unless and until LOTUS FARMS chooses, in it\'s sole discretion and without advance notice to you, to terminate it.</p>' +
      '<p><strong>Use of Platform outside Operating Locations</strong></p>' +
      '<p>LOTUS FARMS makes no representation that the Platform or Products or offers are appropriate or available for use in locations other than the Operating Locations.</p>' +
      '<p><strong>Assignment</strong></p>' +
      '<p>You may not assign your rights and obligations under this Agreement to anyone. LOTUS FARMS may in accordance with applicable law assign it\'s rights and obligations under this Agreement in it\'s sole discretion and without advance notice to you.</p>' +
      '<p><strong>Severability</strong></p>' +
      '<p>In the event that any provision of this Agreement is determined to be unlawful, void or unenforceable, such provision shall nonetheless be enforceable to the fullest extent permitted by applicable law, and the unenforceable portion shall be deemed to be severed from the Agreement, such determination shall not affect the validity and enforceability of any other remaining provisions.</p>' +
      '<p><strong>Conflict</strong></p>' +
      '<p>This Agreement includes, and incorporates by reference, the&nbsp;<a href="https://www.licious.in/privacy-policy">Privacy Policy</a>&nbsp;and any other rules or policies available on the Platform including all other additional or modified terms and conditions and policies in relation to the Platform or any current or future services that may be offered by LOTUS FARMS. In the event of any conflict between the terms of this Agreement and any provision of the polices and guidelines available on the Platform, the terms of this Agreement shall prevail in relation to the subject matter hereof and the terms of such polices and guidelines shall prevail in relation to the subject matter thereof. You are strongly advised to carefully read all such policies and guidelines, as available on the Platform.</p>' +
      '<p><strong>Contact Us</strong></p>' +
      '<p>Please contact us for any questions or comments (including all inquiries unrelated to copyright infringement) regarding this Platform.</p>' +
      '<p>This document is an electronic record in terms of Information Technology Act, 2000 and rules there under as applicable and the amended provisions pertaining to electronic records in various statutes as amended by the Information Technology Act, 2000. This electronic record is generated by a computer system and does not require any physical or digital signatures.</p>' +
      '<p>&nbsp;</p></div>' +
      "</div></body></html>";

  String get terms => _termsCondition;

  setLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  setOfferImageList(List<OffersImg> offerList) {
    this._offerImgList = offerList;
    notifyListeners();
  }

  setNotificationCount(int value) {
    _notificationCount = value;
    notifyListeners();
  }

  setCartCount(int value) {
    myPrint("inserteed cart count is $value");
    _cartCount = value;
    notifyListeners();
  }

  setIntroDone(bool value) {
    _introDone = value;
    notifyListeners();
  }

  init() async {
    try {
      _introDone = await Prefs.introDone;
      _isLogin = await Prefs.login;
      myPrint("intro done is $_introDone");
      // FirebaseMessaging.instance.getToken().then((value) => Prefs.setFcmToken(value));

      if (_isLogin) {
        fetchProfileDetails();
      }
      fetchStoreList();

      final stateResponse = await Prefs.stateList;
      final faq = await Prefs.faq;
      final terms = await Prefs.terms;
      final privacy = await Prefs.privacy;
      if (stateResponse.isEmpty ||
          faq.isEmpty ||
          terms.isEmpty ||
          privacy.isEmpty) {
        fetchStateList();
        _apiService.fetchCMSData("FAQ");
        _apiService.fetchCMSData("Terms & Condition");
        _apiService.fetchCMSData("Privacy Policy");
      } else {
        final data = json.decode(stateResponse);
        for (var item in data) {
          _stateList.add(StateData.fromJson(item));
        }
      }
      myPrint("total states is ${_stateList.length}");
    } catch (e) {
      myPrint(e.toString());
    }
  }

  fetchStoreList() async {
    try {
      final response = await _apiService.fetchStoreList();
      if (response.status == Constants.SUCCESS) {
        _storeList = response.data;
      }
      notifyListeners();
    } catch (e) {
      myPrint(e.toString());
    }
  }

  fetchStateList() async {
    try {
      final response = await _apiService.fetchStateList();
      if (response.status == Constants.SUCCESS) {
        _stateList = response.data;
      }
    } catch (e) {
      myPrint(e.toString());
    }
  }

  fetchProfileDetails() async {
    try {
      final response = await _apiService.fetchProfileDetails();
    } catch (e) {
      myPrint(e.toString());
    }
  }

  setDashboardData(DashboardData data) {
    _dashboardData = data;
    notifyListeners();
  }

  setProductList(List<Product> list) {
    _productList = list;
    notifyListeners();
  }

  setPreOrderList(List<Product> list) {
    _preOrderList = list;
    notifyListeners();
  }
}
