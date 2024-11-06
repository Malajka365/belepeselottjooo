import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../../lib/auth-context';
import { LogOut, FolderPlus, Settings, Library } from 'lucide-react';

const DashboardPage: React.FC = () => {
  const { user, signOut } = useAuth();

  const handleSignOut = async () => {
    try {
      await signOut();
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <h1 className="text-2xl font-bold text-gray-900">My Gallery</h1>
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-gray-700">{user?.email}</span>
              <button
                onClick={handleSignOut}
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-gray-700 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500"
              >
                <LogOut className="w-4 h-4 mr-2" />
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <Link
              to="/dashboard/galleries"
              className="group block p-6 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow"
            >
              <div className="flex items-center">
                <Library className="w-8 h-8 text-blue-500 group-hover:text-blue-600 transition-colors" />
                <div className="ml-4">
                  <h3 className="text-lg font-medium text-gray-900">My Galleries</h3>
                  <p className="mt-1 text-sm text-gray-500">View and manage your video galleries</p>
                </div>
              </div>
            </Link>

            <Link
              to="/dashboard/create"
              className="group block p-6 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow"
            >
              <div className="flex items-center">
                <FolderPlus className="w-8 h-8 text-green-500 group-hover:text-green-600 transition-colors" />
                <div className="ml-4">
                  <h3 className="text-lg font-medium text-gray-900">Create Gallery</h3>
                  <p className="mt-1 text-sm text-gray-500">Create a new video gallery</p>
                </div>
              </div>
            </Link>

            <Link
              to="/dashboard/settings"
              className="group block p-6 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow"
            >
              <div className="flex items-center">
                <Settings className="w-8 h-8 text-purple-500 group-hover:text-purple-600 transition-colors" />
                <div className="ml-4">
                  <h3 className="text-lg font-medium text-gray-900">Settings</h3>
                  <p className="mt-1 text-sm text-gray-500">Manage your account settings</p>
                </div>
              </div>
            </Link>
          </div>
        </div>
      </main>
    </div>
  );
};

export default DashboardPage;