<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Carbon\Carbon;

class LoginRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'phone' => 'required|digits_between:9,15|unique:users,phone',
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'password' => 'required|string|min:6',
            'identity_card_image' => 'required|string',
            'birth_date' => [
                'date',
                'before:' . Carbon::now()->subYears(6)->toDateString(),
            ],
        ];
    }

    public function messages()
    {
        return [
            'phone.required' => 'الرقم مطلوب.',
            'phone.digits_between' => 'الرقم لازم يكون بين 9 و 15 خانة.',
            'phone.unique' => 'الرقم مستخدم بالفعل.',
            'first_name.required' => 'الاسم الأول مطلوب.',
            'last_name.required' => 'الاسم الأخير مطلوب.',
            'password.required' => 'كلمة السر مطلوبة.',
            'password.min' => 'كلمة السر لازم تكون على الأقل 6 خانات.',
            'identity_card_image.required' => 'صورة الهوية مطلوبة.',
            'birth_date.before' => 'تاريخ الميلاد لازم يكون قبل 6 سنوات من الآن.',
        ];
    }
}
