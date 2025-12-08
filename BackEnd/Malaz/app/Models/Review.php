<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    /** @use HasFactory<\Database\Factories\ReviewFactory> */
    use HasFactory;

    public function user()
    {
        return $this->belongsTo('users', 'user_id', 'id');
    }

    public function property()
    {
        return $this->belongsTo('properties', 'property_id', 'id');
    }
}
