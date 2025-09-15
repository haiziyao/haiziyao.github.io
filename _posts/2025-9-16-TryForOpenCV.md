---
layout:     post
title:      "Try by OpenCV"
subtitle:   " \"OpenCV Try\""
date:       2025-09-16 00:00:00
author:     "slef's visitor"
header-img: ""
catalog: true
tags:
    - OpenCV
---

这是本人基于OpenCV所做的第一次小demo，旨在强化学习OpenCV的一些常见基本操作。

以下所有内容是通过

{% raw %}

// 这里放你的代码
Point2f src[4] = {{529,142},{771,190},{405,395},{674,457}};

{% endraw %}

这个玩意包裹，旨在避免报错

``` c++
{% raw %}
#include <cstddef>
#include <iterator>
#include <opencv2/core.hpp>
#include <opencv2/core/mat.hpp>
#include <opencv2/core/types.hpp>
#include <opencv2/opencv.hpp>  // OpenCV 核心头文件
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>
#include <opencv2/videoio.hpp>
#include <vector>
#include <opencv2/objdetect.hpp>
using namespace cv;  // 简化 OpenCV 类/函数调用（避免重复写 cv::）
using namespace std;

void test1();
void test2();
void test3();
void test4();
void test5();
void test6();
void test8();//颜色检测 inRange()  Trackbars
void getContours(Mat imgDil,Mat img); //轮廓识别，去掉面积小于1000的  并识别出来形状
void test9();//形状检测 
void test9_1();//调用摄像头进行轮廓识别
void test10();//检测人脸 
void findcolor();//调用摄像头找最适合的hsv
void test11();//自瞄装甲板,用了getArmour函数
void getArmour(Mat imgMask,Mat img);//bug很多，详情见函数介绍
void test12();//自制虚拟画笔  跳过了
void test13();//文档扫描仪器
void test14();
int main() {
    test11();
    
}
//检测车牌
void test14(){
    VideoCapture cap(0);
    Mat img ;
    CascadeClassifier plateCascade;
    plateCascade.load("../Resources/haarcascade_russian_plate_number.xml");
    if(plateCascade.empty()){cout <<"XML file not loaded"<<endl;}
    vector<Rect> plates;
    while(1){
        cap.read(img);
        plateCascade.detectMultiScale(img,plates,1.1,10);
        for(unsigned int i = 0;i<plates.size();i++){
            rectangle(img,plates[i].tl(),plates[i].br(),Scalar(255,0,255),3);

        }
        imshow("Image",img);
        waitKey(1);
    }
}
//扫描仪器
//img->imgGray->imgBlur->imgCanny>-imgDil
void test13(){
    string path = "../Resources/paper.jpg";
    Mat img = imread(path);
    Mat imgGray,imgBlur,imgCanny,imgDil;
    cvtColor(img, imgGray, COLOR_BGR2GRAY);
    GaussianBlur(imgGray, imgBlur, Size(3,3),5,0);
    Canny(imgBlur,imgCanny,10,50);
    Mat kernel = getStructuringElement(MORPH_RECT, Size(3, 3));
    dilate(imgCanny, imgDil, kernel);
    vector<vector<Point>> contours;
    vector<Vec4i> hierachy;
    findContours(imgDil,contours,hierachy,RETR_EXTERNAL,CHAIN_APPROX_SIMPLE);
    
    if (contours.empty()) {
        cout << "未找到任何轮廓！" << endl;
        return;  
    }

    vector<Point> biggest;
    int bigint = 0;
    int maxarea = 0;
    vector<vector<Point>>  conPoly(contours.size());
    for(unsigned int i = 0;i<contours.size();i++){
            int area = contourArea(contours[i]);
            if(area>1000){
            float peri = arcLength(contours[i], true);
            approxPolyDP(contours[i], conPoly[i], 0.02*peri, true);
            
            if(area>maxarea && conPoly[i].size()==4){
                biggest = conPoly[i];   
                maxarea=area;
                bigint = i;
            }
        }
    }
     
    drawContours(img, conPoly, bigint, Scalar(0,255,0),6);
    for(unsigned int i =0;i<biggest.size();i++){
        circle(img, biggest[i], 5, Scalar(255,0,0),FILLED);
    }
    imshow("img",img);
    waitKey(0);
}
//自制虚拟画笔，先跳过了
void test12(){

}
//自瞄装甲板，已经调的差不多了
void test11(){
    VideoCapture cap(0);
    Mat img,imgHSV,imgMask;
    int hmin = 2,smin=0,vmin=254;
    int hmax =51,smax=255,vmax=255;
    namedWindow("Trackbars", 800);
    createTrackbar("Hue Min", "Trackbars", &hmin, 179);
    createTrackbar("Hue Max", "Trackbars", &hmax, 179);
    createTrackbar("Sat Min", "Trackbars", &smin, 255);
    createTrackbar("Sat Max", "Trackbars", &smax, 255);
    createTrackbar("Val Min", "Trackbars", &vmin, 255);
    createTrackbar("Val Max", "Trackbars", &vmax, 255);
    while(1){
        cap.read(img);
        cvtColor(img, imgHSV, COLOR_BGR2HSV);
        Scalar lower(hmin,smin,vmin);
        Scalar upper(hmax,smax,vmax);
        inRange(imgHSV, lower, upper, imgMask); //筛选颜色过后就是imgMask了
        getArmour(imgMask, img);
        imshow("Vedio",img);
        imshow("imgMask",imgMask);
        waitKey(1);
    }
}
//自瞄装甲板
//底层搞了一个goalboundrect，主要是存储两个红色灯条
//坏处:一旦收到干扰，vector必炸
void getArmour(Mat imgMask,Mat img){
    vector<vector<Point>> contours;
    vector<Vec4i> hierarchy;
    vector<Rect> goalboundRect;
    findContours(imgMask,contours,hierarchy,RETR_EXTERNAL,CHAIN_APPROX_SIMPLE);
    for(unsigned int i =0; i < contours.size();i++){
        
        int area = contourArea(contours[i]);
        //cout << area<<endl;
        //储存每个轮廓的近似点conPoly
        vector<vector<Point>> conPoly(contours.size());
        vector<Rect> boundRect(contours.size());
       
        if (area >20){
            //计算周长 contours[i]：要计算的轮廓  true:闭合曲线
            float peri = arcLength(contours[i], true);
            // argvs: 轮廓，近似点，近似精度，闭合曲线
            approxPolyDP(contours[i], conPoly[i], 0.02*peri, true);
            //边界矩形
            boundRect[i] = boundingRect(conPoly[i]);
            rectangle(img,boundRect[i].tl(),boundRect[i].br(),Scalar(0,255,0),5);    
            goalboundRect.push_back(boundRect[i]);                 
        }       
    }
    if (goalboundRect.size() < 2) {
        cout << "未找到2个有效装甲板，跳过计算！" << endl;
        return;   
    }
    Point mid1 = (goalboundRect[0].tl()+goalboundRect[0].br())/2;
    Point mid2 = (goalboundRect[1].tl()+goalboundRect[1].br())/2;
    double distance = norm(mid1 - mid2);
    Point mid = (mid1+mid2)/2;
    mid1.x = mid.x - distance/2;
    mid1.y = mid.y - distance/2;
    mid2.x = mid.x + distance/2;
    mid2.y = mid.y + distance/2;
    cout<<mid1<<mid<<endl;
    rectangle(img,mid1,mid2,Scalar(0,255,0),5);
    
}
//用来调用摄像头找最适合的颜色区间
void findcolor(){
    int hmin = 0,smin=0,vmin=0;
    int hmax =179,smax=255,vmax=255;
    VideoCapture cap(0);
    Mat img;
    Mat imgHSV,imgMask;
    namedWindow("Trackbars", 800);
    createTrackbar("Hue Min", "Trackbars", &hmin, 179);
    createTrackbar("Hue Max", "Trackbars", &hmax, 179);
    createTrackbar("Sat Min", "Trackbars", &smin, 255);
    createTrackbar("Sat Max", "Trackbars", &smax, 255);
    createTrackbar("Val Min", "Trackbars", &vmin, 255);
    createTrackbar("Val Max", "Trackbars", &vmax, 255);

    while(true){
        cap.read(img);
        cvtColor(img, imgHSV, COLOR_BGR2HSV);
        Scalar lower(hmin,smin,vmin);
        Scalar upper(hmax,smax,vmax);
        inRange(imgHSV, lower, upper, imgMask);

        imshow("img",img);
        imshow("imgHSV",imgHSV);
        imshow("imgMask",imgMask);
        waitKey(1);
    }
}
//人脸检测(直接套用库函数就几行代码)
void test10(){
    VideoCapture cap(0);
    Mat img ;
    CascadeClassifier faceCascade;
    faceCascade.load("../Resources/haarcascade_frontalface_default.xml");
    if(faceCascade.empty()){cout <<"XML file not loaded"<<endl;}
    vector<Rect> faces;
    while(1){
        cap.read(img);
        faceCascade.detectMultiScale(img,faces,1.1,10);
        for(unsigned int i = 0;i<faces.size();i++){
            rectangle(img,faces[i].tl(),faces[i].br(),Scalar(255,0,255),3);

        }
        imshow("Image",img);
        waitKey(1);
    }
}
//第一个自主作业：VideoCapture识别轮廓
void test9_1(){ 
    Mat imgGray,imgBlur,imgCanny,imgDil;
    VideoCapture cap(0);
    Mat img;
    while(1){
        cap.read(img);
        cvtColor(img, imgGray, COLOR_BGR2GRAY);
        GaussianBlur(imgGray, imgBlur, Size(3,3), 3,0);
        Canny(imgBlur,imgCanny,25,75);
        Mat kernel = getStructuringElement(MORPH_RECT, Size(3,3));
        dilate(imgCanny, imgDil, kernel);//记好这个函数叫做膨胀
        getContours(imgDil, img);
        imshow("img",img);
        waitKey(10);
    }
}
//形状检测
void test9(){
    Mat imgGray,imgBlur,imgCanny,imgDil;
    string path = "../Resources/shapes.png";
    Mat img = imread(path);
    cvtColor(img, imgGray, COLOR_BGR2GRAY);
    GaussianBlur(imgGray, imgBlur, Size(3,3), 3,0);
    Canny(imgBlur,imgCanny,25,75);
    Mat kernel = getStructuringElement(MORPH_RECT, Size(3,3));
    dilate(imgCanny, imgDil, kernel);//记好这个函数叫做膨胀
    getContours(imgDil, img);
    imshow("img",img);
    waitKey(0);

}
void getContours(Mat imgDil,Mat img){
    vector<vector<Point>> contours;
    vector<Vec4i> hierarchy;
    findContours(imgDil,contours,hierarchy,RETR_EXTERNAL,CHAIN_APPROX_SIMPLE);
    for(unsigned int i =0; i < contours.size();i++){
        
        int area = contourArea(contours[i]);
        cout << area<<endl;
        //储存每个轮廓的近似点conPoly
        vector<vector<Point>> conPoly(contours.size());
        vector<Rect> boundRect(contours.size());
        string objectType;
        if (area >1000){
            //计算周长 contours[i]：要计算的轮廓  true:闭合曲线
            float peri = arcLength(contours[i], true);
            // argvs: 轮廓，近似点，近似精度，闭合曲线
            approxPolyDP(contours[i], conPoly[i], 0.02*peri, true);
            drawContours(img, conPoly, i, Scalar(255,0,255),3);
            cout<<conPoly[i].size()<<endl;
            //边界矩形
            boundRect[i] = boundingRect(conPoly[i]);
            rectangle(img,boundRect[i].tl(),boundRect[i].br(),Scalar(0,255,0),5);
            
            //
            int objCor = (int)conPoly[i].size(); 
            if (objCor == 3)objectType="Tri";
            if (objCor == 4){
                objectType="Square";
                float aspRatio = (float) boundRect[i].height/(float) boundRect[i].width;
                if(aspRatio>1.05||aspRatio<0.95)objectType="Rect";
                 cout<<aspRatio<<endl;
            }
            if (objCor > 4)objectType="Circle";
            putText(img, objectType, {boundRect[i].x,boundRect[i].y-5}, FONT_HERSHEY_DUPLEX, 0.75, Scalar(75,0,255),2);
        }
    }
     
}
//HSV,mask颜色检测
void test8(){
    int hmin = 0,smin=110,vmin=153;
    int hmax =19,smax=240,vmax=255;
    string path = "../Resources/lambo.png";
    Mat img = imread(path);
    Mat imgHSV,imgMask;
    cvtColor(img, imgHSV, COLOR_BGR2HSV);
    
    namedWindow("Trackbars", 400);
    createTrackbar("Hue Min", "Trackbars", &hmin, 179);
    createTrackbar("Hue Max", "Trackbars", &hmax, 179);
    createTrackbar("Sat Min", "Trackbars", &smin, 255);
    createTrackbar("Sat Max", "Trackbars", &smax, 255);
    createTrackbar("Val Min", "Trackbars", &vmin, 255);
    createTrackbar("Val Max", "Trackbars", &vmax, 255);

    while(true){
        Scalar lower(hmin,110,153);
        Scalar upper(19,240,255);
        inRange(imgHSV, lower, upper, imgMask);
        imshow("img",img);
        imshow("imgHSV",imgHSV);
        imshow("imgMask",imgMask);
        waitKey(1);
    }
}
//warpPerspective
void test7(){
    float w=250,h=350;
    Mat matrix,imgWarp;
    string path = "../Resources/cards.jpg";
    Mat img = imread(path);
    Point2f src[4] = {{529,142},{771,190},{405,395},{674,457}};
    Point2f des[4] = {{0.0f,0.0f},{w,0.0f},{0.0f,h},{w,h}};
    matrix = getPerspectiveTransform(src,des);
    warpPerspective(img, imgWarp, matrix, Point(w,h));
    for (int i =0;i<4;i++) {
        circle(img, src[i], 8, Scalar(0,0,255),FILLED);
    }
    imshow("Image",img);
    imshow("imgWarp",imgWarp);
    waitKey(0);
}
//draw
void test6(){
    Mat img(512,512,CV_8UC3,Scalar(255,255,255));

    circle(img, Point(256,256), 155,  Scalar(78,0,255),FILLED);
    rectangle(img,Point(130,226),Point(382,286),Scalar(0,0,0),FILLED);
    line(img,Point(130,260),Point(382,260),Scalar(0,0,0),2);

    putText(img, "This is HZY", Point(130,240), FONT_HERSHEY_DUPLEX, 0.75, Scalar(75,0,255),2);
    imshow("img",img);
    waitKey(0);

}
//resize and crop
void test5(){
    string path = "../Resources/test.png";
    Mat img = imread(path);
    Mat imgResize,imgCrop;
    resize(img, imgResize, Size(0,0),0.5,0.5);
    Rect roi(200,100,200,300);
    imgCrop = img(roi);

    imshow("imgResize",imgResize);
    imshow("imgCrop",imgCrop);
    waitKey(0);
}
//convert
void test4(){
    string path = "../Resources/test.png";
    Mat img = imread(path);
    Mat imgGray,imgBlur,imgcanny,imgDil,imgErode;
    cvtColor(img,imgGray,COLOR_BGR2GRAY);
    GaussianBlur(img,imgBlur, Size(7,7),5,0);
    Canny(  imgBlur,imgcanny,50,150);
    Mat kernel = getStructuringElement(MORPH_RECT, Size(3,3));
    
    dilate(imgcanny, imgDil,  kernel);
    erode(imgDil, imgErode, kernel);
    
    
    imshow("img",img);
    imshow("imgGray",imgGray);
    imshow("imgBlur",imgBlur);
    imshow("imgcanny",imgcanny);
    imshow("imgDila",imgDil);
    imshow("imgErode",imgErode);
    waitKey(0);
    
    
}

void test3(){
    VideoCapture cap(0);
    Mat img;
    while(1){
        cap.read(img);
        imshow("Vedio",img);
        waitKey(1);
    }
}

void test2(){
    string path = "../Resources/test_video.mp4";
    VideoCapture cap(path);
    Mat img;
    while(true){
        cap.read(img);
        imshow("Image",img);
        waitKey(1);
    }
    
}

void test1(){
    string path = "../Resources/test.png";
    Mat img = imread(path);
    imshow("Image",img);
    waitKey(20);
}
{% endraw %}
```