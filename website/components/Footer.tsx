export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-white dark:bg-gray-950 border-t border-gray-200 dark:border-gray-800">
      <div className="mx-auto max-w-7xl px-6 py-12 lg:px-8">
        <div className="md:flex md:items-center md:justify-between">
          <div className="flex justify-center space-x-6 md:order-2">
            <a
              href="https://github.com/hazelguo/baseper"
              className="text-gray-500 hover:text-gray-600 dark:text-gray-400 dark:hover:text-gray-300"
              target="_blank"
              rel="noopener noreferrer"
            >
              GitHub
            </a>
            <a
              href="https://github.com/hazelguo/baseper/blob/main/README.md"
              className="text-gray-500 hover:text-gray-600 dark:text-gray-400 dark:hover:text-gray-300"
              target="_blank"
              rel="noopener noreferrer"
            >
              Documentation
            </a>
            <a
              href="https://github.com/hazelguo/baseper/issues"
              className="text-gray-500 hover:text-gray-600 dark:text-gray-400 dark:hover:text-gray-300"
              target="_blank"
              rel="noopener noreferrer"
            >
              Issues
            </a>
            <a
              href="https://github.com/hazelguo/baseper/blob/main/LICENSE"
              className="text-gray-500 hover:text-gray-600 dark:text-gray-400 dark:hover:text-gray-300"
              target="_blank"
              rel="noopener noreferrer"
            >
              Elastic License 2.0
            </a>
          </div>
          <div className="mt-8 md:order-1 md:mt-0">
            <p className="text-center text-sm text-gray-500 dark:text-gray-400">
              &copy; {currentYear} Baseper — Free, open source speech to text for macOS.
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
}
