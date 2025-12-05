<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\Property;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    /**
     * Display a list of bookings.
     */
    public function index()
    {
        // Show all bookings for the authenticated user
        return Booking::where('user_id', auth()->id())->with('property')->get();
    }

    /**
     * Store a new booking.
     */
    public function store(Request $request)
    {
        $request->validate([
            'property_id' => 'required|exists:properties,id',
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
            'total_price' => 'required|numeric|min:0',
            'currency' => 'string|size:3',
        ]);

        $propertyId = $request->property_id;
        $checkIn = $request->check_in;
        $checkOut = $request->check_out;

        // Prevent double-booking
        $overlap = Booking::where('property_id', $propertyId)
            ->where('status', 'confirmed')
            ->where(function ($query) use ($checkIn, $checkOut) {
                $query->whereBetween('check_in', [$checkIn, $checkOut])
                    ->orWhereBetween('check_out', [$checkIn, $checkOut])
                    ->orWhere(function ($q) use ($checkIn, $checkOut) {
                        $q->where('check_in', '<', $checkIn)
                            ->where('check_out', '>', $checkOut);
                    });
            })
            ->exists();

        if ($overlap) {
            return response()->json(['error' => 'Property already booked for these dates'], 422);
        }

        // Create booking
        $booking = Booking::create([
            'user_id' => auth()->id(),
            'property_id' => $propertyId,
            'check_in' => $checkIn,
            'check_out' => $checkOut,
            'status' => 'pending',
            'total_price' => $request->total_price,
            'currency' => $request->currency ?? 'USD',
            'payment_status' => 'unpaid',
        ]);

        return response()->json($booking, 201);
    }

    /**
     * Show a single booking.
     */
    public function show(Booking $booking)
    {
        $this->authorize('view', $booking); // optional policy
        return $booking->load('property');
    }

    /**
     * Update a booking (e.g., confirm, cancel).
     */
    public function update(Request $request, Booking $booking)
    {
        $this->authorize('update', $booking);

        $request->validate([
            'status' => 'in:pending,confirmed,cancelled,completed',
            'payment_status' => 'in:unpaid,paid,refunded',
        ]);

        $booking->update($request->only('status', 'payment_status'));

        return response()->json($booking);
    }

    /**
     * Delete a booking.
     */
    public function destroy(Booking $booking)
    {
        $this->authorize('delete', $booking);
        $booking->delete();

        return response()->json(['message' => 'Booking deleted successfully']);
    }

    public function availability($propertyId)
    {
        // Validate property exists
        $property = Property::findOrFail($propertyId);

        // Get pending + confirmed bookings for this property
        $bookings = Booking::where('property_id', $propertyId)
            ->whereIn('status', ['pending', 'confirmed'])
            ->select('check_in', 'check_out', 'status')
            ->get();

        // Return booked date ranges with status
        return response()->json([
            'booked_ranges' => $bookings
        ]);
    }
}
