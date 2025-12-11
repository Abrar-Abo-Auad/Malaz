<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePropertyRequest extends FormRequest
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
            'price' => 'integer|min:0',
            'description' => 'nullable|string|max:1000',
            'images' => 'nullable|array',
            'images.*' => 'file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'erase' => 'nullable|array',
            'erase.*' => 'integer',
            'type' => 'string|in:Apartment,Farm,Villa,Restaurant,Travel Rest Stop,Residential Tower,Country Estate',
            'number_of_rooms' => 'integer|min:0',
        ];
    }

    public function messages()
    {
        return [
            'price.integer' => 'Price must be an integer.',
            'price.min' => 'Price cannot be less than zero.',
            'description.string' => 'Description must be a string.',
            'description.max' => 'Description cannot exceed 1000 characters.',
            'images.array' => 'Images must be an array.',
            'images.*.file' => 'Each image must be a file.',
            'images.*.image' => 'Each file must be an image.',
            'images.*.mimes' => 'Images must be of type: jpeg, png, jpg, gif, svg.',
            'images.*.max' => 'Each image must not exceed 2MB.',
            'erase.array' => 'Erase must be an array.',
            'erase.*.integer' => 'Each erase item must be an integer (image ID).',
            'type.string' => 'Type must be a string.',
            'type.in' => 'Type must be one of: Apartment, Farm, Villa, Restaurant, Travel Rest Stop, Residential Tower, Country Estate.',
            'number_of_rooms.integer' => 'Number of rooms must be an integer.',
            'number_of_rooms.min' => 'Number of rooms cannot be less than zero.',
        ];
    }
}
