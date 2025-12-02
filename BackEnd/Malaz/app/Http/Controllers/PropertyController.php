<?php

namespace App\Http\Controllers;

use Auth;
use App\Models\Property;
use Illuminate\Http\Request;
use App\Http\Requests\storeproperty;

class PropertyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function my_properties()
    {
        $user = auth()->user();
        $properties = $user->properties()->get();
        return response()->json(
            [
                'data' => $properties,
                'message' => 'here all your properties',
                'status' => 200,
            ]
        );
    }

    public function all_properties()
    {
        $properties = Property::all();
        return response()->json(
            [
                'data' => $properties,
                'message' => 'here all properties',
                'status' => 200,
            ]
        );
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {

    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(storeproperty $request)
    {
        $user = auth()->user();
        $validated = $request->validated();
        $validated['owner_id'] = $user->id;
        $property = Property::create($validated);
        return response()->json([
            'data' => $property,
            'message' => 'Property created successfully',
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Property $property)
    {
        return response()->json([
            'data' => $property,
            'message' => 'Property returned successfully',
        ], 201);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Property $property)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Property $property)
    {
        $this->authorize('update', $property);
        $validated = $request->validate([
            'is_rented' => 'boolean',
            'price' => 'integer|min:0',
            'description' => 'nullable|string|max:1000',
        ]);
        $property->update($validated);

        return response()->json([
            'property' => $property,
            'message' => 'update completed',
            'status' => 200,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Property $property)
    {
        $this->authorize('delete', $property);
        $property->delete();
        return response()->json([
            'message' => 'Property deleted',
            'status' => 200,
        ]);
    }
}
