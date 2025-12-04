<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EditRequest extends Model
{
    /** @use HasFactory<\Database\Factories\EditRequestFactory> */
    use HasFactory;
    protected $casts = [
        'old_data' => 'array',
        'new_data' => 'array',
    ];
    protected $fillable = ['user_id', 'old_data', 'new_data', 'status', 'reviewed_by', 'reviewed_at'];
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }


        protected $guarded = [];
}
