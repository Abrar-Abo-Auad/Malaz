<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\PropertyController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');


Route::prefix('user')->controller(UserController::class)->group(function () {
    Route::post('/sendOtp', 'sendOtp');
    Route::post('/verifyOtp', 'verifyOtp');
    Route::get('/info', 'info');
    Route::post('/register', 'register');
    Route::post('/login', 'login');
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', 'logout');
        Route::get('/me', 'me');
    });
});

Route::prefix('property')->controller(PropertyController::class)->group(function () {
    Route::get('/all_properties', 'all_properties');
    Route::get('/show/{property}', 'show');
    Route::middleware(['auth:sanctum', 'role:ADMIN,OWNER'])->group(function () {
        Route::get('/my_properties', 'my_properties');
        Route::post('/store', 'store');
        Route::patch('/update/{property}', 'update');
        Route::delete('/destroy/{property}', 'destroy');
    });
});
