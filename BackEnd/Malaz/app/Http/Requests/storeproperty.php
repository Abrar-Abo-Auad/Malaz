<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class storeproperty extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'price' => 'required|integer|min:0',
            'city' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'governorate' => 'required|string|max:255',
            'latitude' => 'numeric',
            'longitude' => 'numeric',
            'description' => 'nullable|string|max:1000',
        ];
    }

    public function messages(): array
    {
        return [
            'price.required' => 'Price is required.',
            'price.integer' => 'Price must be an integer.',
            'price.min' => 'Price must be greater than or equal to zero.',

            'owner_id.required' => 'Owner ID is required.',
            'owner_id.exists' => 'The specified owner does not exist.',

            'city.required' => 'City name is required.',
            'city.string' => 'City name must be a string.',
            'city.max' => 'City name must not exceed 255 characters.',

            'address.required' => 'Address is required.',
            'address.string' => 'Address must be a string.',
            'address.max' => 'Address must not exceed 255 characters.',

            'governorate.required' => 'Governorate is required.',
            'governorate.string' => 'Governorate must be a string.',
            'governorate.max' => 'Governorate must not exceed 255 characters.',

            'latitude.numeric' => 'Latitude must be a numeric value.',

            'longitude.numeric' => 'Longitude must be a numeric value.',

            'description.string' => 'Description must be a string.',
            'description.max' => 'Description must not exceed 1000 characters.',
        ];
    }
}
