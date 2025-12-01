<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Requests\RegisterRequest;

class UserController extends Controller
{
    public function register(RegisterRequest $request)
    {
        $user = User::create([
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'phone' => $request->phone,
            'password' => bcrypt($request->password),
            'identity_card_image' => $request->identity_card_image,
            'birth_date' => $request->birth_date,
        ]);

        return response()->json(['message' => 'User created Wait until it is approved by the officials', 'data' => $user], 201);

    }

    public function login(Request $request)
    {
        $request->validate([
            'phone' => 'required|digits_between:9,15',
            'password' => 'required',
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        $user = Auth::user();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 500);
        }

        try {
            $token = $user->createToken('api-token')->plainTextToken;
        } catch (\Exception $e) {
            return response()->json(['message' => 'Token creation failed'], 500);
        }

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ]);
    }


    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out']);
    }

    public function me(Request $request)
    {
        return response()->json($request->user());
    }
}
