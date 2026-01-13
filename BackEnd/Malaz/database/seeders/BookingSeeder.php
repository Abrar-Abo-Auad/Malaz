<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Booking;
use App\Models\Property;
use App\Models\User;
use Carbon\Carbon;

class BookingSeeder extends Seeder
{
    public function run()
    {
        // Create a property (owner created by factory)
        $property = Property::factory()->create();

        // Create a booking user
        $user = User::factory()->create();

        // Past confirmed booking (should be completed by command)
        Booking::create([
            'user_id' => $user->id,
            'property_id' => $property->id,
            'check_in' => Carbon::today()->subDays(10)->toDateString(),
            'check_out' => Carbon::today()->subDays(5)->toDateString(),
            'status' => 'confirmed',
            'total_price' => 150.00,
        ]);

        // Recent past confirmed booking (yesterday)
        Booking::create([
            'user_id' => $user->id,
            'property_id' => $property->id,
            'check_in' => Carbon::today()->subDays(3)->toDateString(),
            'check_out' => Carbon::today()->subDays(1)->toDateString(),
            'status' => 'confirmed',
            'total_price' => 80.00,
        ]);

        // Future confirmed booking (should remain confirmed)
        Booking::create([
            'user_id' => $user->id,
            'property_id' => $property->id,
            'check_in' => Carbon::today()->addDays(2)->toDateString(),
            'check_out' => Carbon::today()->addDays(5)->toDateString(),
            'status' => 'confirmed',
            'total_price' => 200.00,
        ]);

        // Past pending booking (should NOT be changed by command)
        Booking::create([
            'user_id' => $user->id,
            'property_id' => $property->id,
            'check_in' => Carbon::today()->subDays(8)->toDateString(),
            'check_out' => Carbon::today()->subDays(2)->toDateString(),
            'status' => 'pending',
            'total_price' => 120.00,
        ]);
    }
}
