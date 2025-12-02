<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Property extends Model
{
    /** @use HasFactory<\Database\Factories\PropertyFactory> */
    use HasFactory;

    public function images()
    {
        return $this->hasMany(Image::class, 'property_id', 'id');
    }

    public function users()
    {
        return $this->belongsTo(User::class);
    }

    protected $guarded = [];
}
